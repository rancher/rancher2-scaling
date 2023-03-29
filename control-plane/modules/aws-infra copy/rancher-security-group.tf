resource "aws_security_group" "rancher_server" {
  count  = var.create_rancher_security_group ? 1 : 0
  name   = "${local.name}-self"
  vpc_id = data.aws_vpc.default.id
  tags = {
    for tag in local.custom_tags : "${tag.key}" => "${tag.value}"
  }
}

# resource "aws_security_group_rule" "self_self" {
#   count = var.create_rancher_security_group ? 1 : 0
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   self              = true
#   security_group_id = aws_security_group.rancher_server[0].id
# }

resource "aws_security_group_rule" "self_rke1_server" {
  count             = var.create_rancher_security_group ? 1 : 0
  type              = "ingress"
  from_port         = 6443
  to_port           = 6443
  protocol          = "TCP"
  cidr_blocks       = local.private_subnets_cidr_blocks
  security_group_id = aws_security_group.rancher_server[0].id
}

resource "aws_security_group_rule" "self_dockerd_tls" {
  count             = var.create_rancher_security_group ? 1 : 0
  type              = "ingress"
  from_port         = 2376
  to_port           = 2376
  protocol          = "TCP"
  cidr_blocks       = local.private_subnets_cidr_blocks
  security_group_id = aws_security_group.rancher_server[0].id
}

resource "aws_security_group_rule" "self_etcd_comms" {
  count             = var.create_rancher_security_group ? 1 : 0
  type              = "ingress"
  from_port         = 2379
  to_port           = 2380
  protocol          = "TCP"
  self              = true
  security_group_id = aws_security_group.rancher_server[0].id
}

resource "aws_security_group_rule" "self_vxlan" {
  count             = var.create_rancher_security_group ? 1 : 0
  type              = "ingress"
  from_port         = 8472
  to_port           = 8472
  protocol          = "UDP"
  self              = true
  security_group_id = aws_security_group.rancher_server[0].id
}

resource "aws_security_group_rule" "self_vxlan_liveness_readiness" {
  count             = var.create_rancher_security_group ? 1 : 0
  type              = "ingress"
  from_port         = 9099
  to_port           = 9099
  protocol          = "TCP"
  self              = true
  security_group_id = aws_security_group.rancher_server[0].id
}

resource "aws_security_group_rule" "self_prom_metrics_linux" {
  count             = var.create_rancher_security_group ? 1 : 0
  type              = "ingress"
  from_port         = 9100
  to_port           = 9100
  protocol          = "TCP"
  self              = true
  security_group_id = aws_security_group.rancher_server[0].id
}

resource "aws_security_group_rule" "self_prom_metrics_windows" {
  count             = var.create_rancher_security_group ? 1 : 0
  type              = "ingress"
  from_port         = 9796
  to_port           = 9796
  protocol          = "TCP"
  self              = true
  security_group_id = aws_security_group.rancher_server[0].id
}

resource "aws_security_group_rule" "self_kubelet" {
  count             = var.create_rancher_security_group ? 1 : 0
  type              = "ingress"
  from_port         = 10250
  to_port           = 10250
  protocol          = "TCP"
  self              = true
  security_group_id = aws_security_group.rancher_server[0].id
}

resource "aws_security_group_rule" "self_ingress_liveness_readiness" {
  count             = var.create_rancher_security_group ? 1 : 0
  type              = "ingress"
  from_port         = 10254
  to_port           = 10254
  protocol          = "TCP"
  self              = true
  security_group_id = aws_security_group.rancher_server[0].id
}

resource "aws_security_group_rule" "self_nodeport_range" {
  count             = var.create_rancher_security_group ? 1 : 0
  type              = "ingress"
  from_port         = 30000
  to_port           = 32767
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rancher_server[0].id
}

resource "aws_security_group_rule" "rke1_server_egress" {
  count             = var.create_rancher_security_group ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rancher_server[0].id
}

resource "aws_security_group_rule" "ssh_rke1_server" {
  count             = var.create_rancher_security_group ? 1 : 0
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rancher_server[0].id
}
