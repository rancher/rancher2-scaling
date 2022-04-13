#############################
### Access Control
#############################

resource "aws_security_group" "ingress" {
  name   = "${local.name}-ingress"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ingress.id
}

resource "aws_security_group_rule" "ingress_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ingress.id
}

resource "aws_security_group_rule" "ingress_self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.ingress.id
}

resource "aws_security_group_rule" "ingress_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ingress.id
}

resource "aws_security_group" "self" {
  name   = "${local.name}-self"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "self_self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.self.id
}

resource "aws_security_group_rule" "self_k3s_server" {
  type              = "ingress"
  from_port         = 6443
  to_port           = 6443
  protocol          = "TCP"
  cidr_blocks       = local.private_subnets_cidr_blocks
  security_group_id = aws_security_group.self.id
}

resource "aws_security_group_rule" "k3s_server_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.self.id
}

resource "aws_security_group_rule" "ssh_k3s_server" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.self.id
}

#############################
### Create Nodes
#############################

data "aws_iam_instance_profile" "rancher_s3_access" {
  count = (length(var.byo_certs_bucket_path) > 0 && length(local.s3_instance_profile) > 0) ? 1 : 0
  name  = local.s3_instance_profile
}

resource "aws_launch_template" "k3s_server" {
  # if at least 2 server nodes, 1 will be the leader and 1 will be a joining server
  count         = local.server_node_count > 1 ? 2 : 1
  name          = count.index == 0 ? "${local.name}-leader" : "${local.name}-server"
  image_id      = local.server_image_id
  instance_type = local.server_instance_type
  user_data     = count.index == 0 ? data.cloudinit_config.k3s_server[0].rendered : data.cloudinit_config.k3s_server[1].rendered

  iam_instance_profile {
    arn = length(var.byo_certs_bucket_path) > 0 ? data.aws_iam_instance_profile.rancher_s3_access[0].arn : null
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      encrypted   = true
      volume_type = "gp2"
      volume_size = "50"
    }
  }

  network_interfaces {
    delete_on_termination = true
    security_groups       = concat([aws_security_group.ingress.id, aws_security_group.self.id, var.db_security_group], local.rancher_sg, var.extra_server_security_groups)
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_template" "k3s_agent" {
  count         = local.agent_node_count > 0 && var.create_agent_nlb ? 1 : 0
  name          = "${local.name}-agent"
  image_id      = local.agent_image_id
  instance_type = local.agent_instance_type
  user_data     = data.cloudinit_config.k3s_agent[0].rendered

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      encrypted   = true
      volume_type = "gp2"
      volume_size = "50"
    }
  }

  network_interfaces {
    delete_on_termination = true
    security_groups       = concat([aws_security_group.ingress.id, aws_security_group.self.id], local.rancher_sg, var.extra_server_security_groups)
  }

  tags = {
    Name           = "${local.name}-agent"
    "rancher.user" = var.user

  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "k3s_leader" {
  name                = "${local.name}-leader"
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = local.private_subnets

  target_group_arns = [
    aws_lb_target_group.server-6443.arn,
    aws_lb_target_group.server-80.arn,
    aws_lb_target_group.server-443.arn
  ]

  launch_template {
    id      = aws_launch_template.k3s_server[0].id
    version = aws_launch_template.k3s_server[0].latest_version
  }

  lifecycle {
    create_before_destroy = true
  }

  dynamic "tag" {
    for_each = merge({
      "Name" = "${local.name}-leader-nodepool"
    }, local.tags)

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_autoscaling_group" "k3s_server" {
  name                = "${local.name}-server"
  desired_capacity    = local.server_node_count - 1
  max_size            = local.server_node_count - 1
  min_size            = local.server_node_count - 1
  vpc_zone_identifier = local.private_subnets

  target_group_arns = [
    aws_lb_target_group.server-6443.arn,
    aws_lb_target_group.server-80.arn,
    aws_lb_target_group.server-443.arn
  ]

  launch_template {
    id      = aws_launch_template.k3s_server[1].id
    version = aws_launch_template.k3s_server[1].latest_version
  }

  lifecycle {
    create_before_destroy = true
  }

  dynamic "tag" {
    for_each = merge({
      "Name" = "${local.name}-server-nodepool"
    }, local.tags)

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  depends_on = [
    aws_autoscaling_group.k3s_leader
  ]
}

resource "aws_autoscaling_group" "k3s_agent" {
  count               = local.agent_node_count > 0 && var.create_agent_nlb ? 1 : 0
  name                = "${local.name}-agent"
  desired_capacity    = local.agent_node_count
  max_size            = local.agent_node_count
  min_size            = local.agent_node_count
  vpc_zone_identifier = local.private_subnets

  target_group_arns = [
    aws_lb_target_group.agent-80[0].arn,
    aws_lb_target_group.agent-443[0].arn
  ]

  launch_template {
    id      = aws_launch_template.k3s_agent[0].id
    version = aws_launch_template.k3s_agent[0].latest_version
  }

  dynamic "tag" {
    for_each = merge({
      "Name" = "${local.name}-agent-nodepool"
    }, local.tags)

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_autoscaling_group.k3s_server
  ]
}

#############################
### Create Public Rancher DNS
#############################
resource "aws_route53_record" "rancher" {
  count   = local.use_route53
  zone_id = data.aws_route53_zone.dns_zone[0].zone_id
  name    = "${local.subdomain}.${local.domain}"
  type    = "CNAME"
  ttl     = 30
  records = [aws_lb.server-public-lb.dns_name]
}

### commenting this out since we currently have no practical need to rely on multiple
### private + public LBs for cluster access
# resource "aws_route53_record" "k3s" {
#   count   = local.use_route53
#   zone_id = data.aws_route53_zone.dns_zone[0].zone_id
#   name    = "${local.subdomain}-int.${local.domain}"
#   type    = "CNAME"
#   ttl     = 30
#   records = [aws_lb.server_lb.dns_name]
# }
