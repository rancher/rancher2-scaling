#############################
### Access Control
#############################

resource "aws_security_group" "ingress" {
  name   = "${local.name}-ingress"
  vpc_id = data.aws_vpc.default.id
  tags = {
    for tag in [{ key = local.k8s_cluster_tag, value = "shared" }] : "${tag.key}" => "${tag.value}"
  }
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
  tags = {
    for tag in local.custom_tags : "${tag.key}" => "${tag.value}"
  }
}

# resource "aws_security_group_rule" "self_self" {
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   self              = true
#   security_group_id = aws_security_group.self.id
# }

resource "aws_security_group_rule" "self_rke1_server" {
  type              = "ingress"
  from_port         = 6443
  to_port           = 6443
  protocol          = "TCP"
  cidr_blocks       = local.private_subnets_cidr_blocks
  security_group_id = aws_security_group.self.id
}

resource "aws_security_group_rule" "self_dockerd_tls" {
  type              = "ingress"
  from_port         = 2376
  to_port           = 2376
  protocol          = "TCP"
  cidr_blocks       = local.private_subnets_cidr_blocks
  security_group_id = aws_security_group.self.id
}

resource "aws_security_group_rule" "self_etcd_comms" {
  type              = "ingress"
  from_port         = 2379
  to_port           = 2380
  protocol          = "TCP"
  self              = true
  security_group_id = aws_security_group.self.id
}

resource "aws_security_group_rule" "self_vxlan" {
  type              = "ingress"
  from_port         = 8472
  to_port           = 8472
  protocol          = "UDP"
  self              = true
  security_group_id = aws_security_group.self.id
}

resource "aws_security_group_rule" "self_vxlan_liveness_readiness" {
  type              = "ingress"
  from_port         = 9099
  to_port           = 9099
  protocol          = "TCP"
  self              = true
  security_group_id = aws_security_group.self.id
}

resource "aws_security_group_rule" "self_prom_metrics_linux" {
  type              = "ingress"
  from_port         = 9100
  to_port           = 9100
  protocol          = "TCP"
  self              = true
  security_group_id = aws_security_group.self.id
}

resource "aws_security_group_rule" "self_prom_metrics_windows" {
  type              = "ingress"
  from_port         = 9796
  to_port           = 9796
  protocol          = "TCP"
  self              = true
  security_group_id = aws_security_group.self.id
}

resource "aws_security_group_rule" "self_kubelet" {
  type              = "ingress"
  from_port         = 10250
  to_port           = 10250
  protocol          = "TCP"
  self              = true
  security_group_id = aws_security_group.self.id
}

resource "aws_security_group_rule" "self_ingress_liveness_readiness" {
  type              = "ingress"
  from_port         = 10254
  to_port           = 10254
  protocol          = "TCP"
  self              = true
  security_group_id = aws_security_group.self.id
}

resource "aws_security_group_rule" "self_nodeport_range" {
  type              = "ingress"
  from_port         = 30000
  to_port           = 32767
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.self.id
}

resource "aws_security_group_rule" "rke1_server_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.self.id
}

resource "aws_security_group_rule" "ssh_rke1_server" {
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
  count = length(local.s3_instance_profile) > 0 ? 1 : 0
  name  = local.s3_instance_profile
}

resource "aws_launch_template" "rke1_server" {
  name_prefix   = local.name
  image_id      = local.server_image_id
  instance_type = local.server_instance_type
  user_data     = data.cloudinit_config.rke1_server.rendered

  iam_instance_profile {
    arn = length(local.s3_instance_profile) > 0 ? data.aws_iam_instance_profile.rancher_s3_access[0].arn : null
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      encrypted   = true
      volume_type = "gp2"
      volume_size = var.volume_size
    }
  }

  network_interfaces {
    delete_on_termination = true
    security_groups       = concat([aws_security_group.ingress.id, aws_security_group.self.id], var.extra_server_security_groups)
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "rke1_server" {
  name_prefix         = local.name
  desired_capacity    = local.server_node_count
  max_size            = local.server_node_count
  min_size            = local.server_node_count
  vpc_zone_identifier = local.private_subnets

  target_group_arns = [
    aws_lb_target_group.server-6443.arn,
    aws_lb_target_group.server-80.arn,
    aws_lb_target_group.server-443.arn
  ]

  launch_template {
    id      = aws_launch_template.rke1_server.id
    version = aws_launch_template.rke1_server.latest_version
  }

  lifecycle {
    create_before_destroy = true
  }

  dynamic "tag" {
    for_each = local.asg_tags
    content {
      key                 = tag.value.key
      value               = tag.value.value
      propagate_at_launch = true
    }
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
  records = [aws_lb.server-public-lb.dns_name]
}

resource "aws_route53_record" "rke1" {
  count   = local.use_route53
  zone_id = data.aws_route53_zone.dns_zone.0.zone_id
  name    = "${local.subdomain}-int.${local.domain}"
  type    = "CNAME"
  ttl     = 30
  records = [aws_lb.server_lb.dns_name]
}
