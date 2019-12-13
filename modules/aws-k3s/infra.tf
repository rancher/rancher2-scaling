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
resource "aws_launch_template" "k3s_server" {
  name_prefix   = "${local.name}-server"
  image_id      = local.server_image_id
  instance_type = local.server_instance_type
  user_data     = data.template_cloudinit_config.k3s_server.rendered

  instance_market_options {
    market_type = "spot"
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
    security_groups       = concat([aws_security_group.self.id, var.db_security_group], var.extra_server_security_groups)
  }

  tags = {
    Name           = "${local.name}-server"
    "rancher.user" = var.user

  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name           = "${local.name}-server"
      "rancher.user" = var.user

    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_template" "k3s_agent" {
  name_prefix   = "${local.name}-agent"
  image_id      = local.agent_image_id
  instance_type = local.agent_instance_type
  user_data     = data.template_cloudinit_config.k3s_agent.rendered

  instance_market_options {
    market_type = "spot"
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
    security_groups       = concat([aws_security_group.ingress.id, aws_security_group.self.id], var.extra_agent_security_groups)
  }

  tags = {
    Name           = "${local.name}-agent"
    "rancher.user" = var.user

  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name           = "${local.name}-agent"
      "rancher.user" = var.user

    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "k3s_server" {
  name_prefix         = "${local.name}-server"
  desired_capacity    = local.server_node_count
  max_size            = local.server_node_count
  min_size            = local.server_node_count
  vpc_zone_identifier = local.private_subnets

  target_group_arns = [
    aws_lb_target_group.server-6443.arn
  ]

  launch_template {
    id      = aws_launch_template.k3s_server.id
    version = aws_launch_template.k3s_server.latest_version
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "k3s_agent" {
  name_prefix         = "${local.name}-agent"
  desired_capacity    = local.agent_node_count
  max_size            = local.agent_node_count
  min_size            = local.agent_node_count
  vpc_zone_identifier = local.private_subnets

  target_group_arns = [
    aws_lb_target_group.agent-80.0.arn,
    aws_lb_target_group.agent-443.0.arn
  ]

  launch_template {
    id      = aws_launch_template.k3s_agent.id
    version = aws_launch_template.k3s_agent.latest_version
  }

  lifecycle {
    create_before_destroy = true
  }
}

#############################
### Create Public Rancher DNS
#############################
resource "aws_route53_record" "rancher" {
  count   = local.use_route53
  zone_id = data.aws_route53_zone.dns_zone.0.zone_id
  name    = "${local.subdomain}.${local.domain}"
  type    = "CNAME"
  ttl     = 30
  records = [aws_lb.lb.0.dns_name]
}

resource "aws_route53_record" "k3s" {
  count   = local.use_route53
  zone_id = data.aws_route53_zone.dns_zone.0.zone_id
  name    = "${local.subdomain}-k3s.${local.domain}"
  type    = "CNAME"
  ttl     = 30
  records = [aws_lb.server-lb.dns_name]
}