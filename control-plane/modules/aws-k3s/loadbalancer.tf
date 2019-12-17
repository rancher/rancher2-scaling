resource "aws_lb" "server-lb" {
  name               = "${local.name}-int"
  internal           = true
  load_balancer_type = "network"
  subnets            = local.private_subnets

  tags = {
    "kubernetes.io/cluster/${local.name}" = ""
    "rancher.user"                        = var.user
  }

}

resource "aws_lb_listener" "server-port_6443" {
  load_balancer_arn = aws_lb.server-lb.arn
  port              = "6443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.server-6443.arn
  }
}

resource "aws_lb_target_group" "server-6443" {
  name     = "${local.name}-server-6443"
  port     = 6443
  protocol = "TCP"
  vpc_id   = data.aws_vpc.default.id
}


resource "aws_lb" "lb" {
  count              = local.create_external_nlb
  name               = "${local.name}-ext"
  internal           = false
  load_balancer_type = "network"
  subnets            = local.public_subnets

  tags = {
    "kubernetes.io/cluster/${local.name}" = ""
    "rancher.user"                        = var.user
  }
}

resource "aws_lb_listener" "port_443" {
  count             = local.create_external_nlb
  load_balancer_arn = aws_lb.lb.0.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.agent-443.0.arn
  }
}

resource "aws_lb_listener" "port_80" {
  count             = local.create_external_nlb
  load_balancer_arn = aws_lb.lb.0.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.agent-80.0.arn
  }
}

resource "aws_lb_target_group" "agent-443" {
  count    = local.create_external_nlb
  name     = "${local.name}-agent-443"
  port     = 443
  protocol = "TCP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    interval            = 10
    timeout             = 6
    path                = ""
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = ""
  }

  stickiness {
    type    = "lb_cookie"
    enabled = false
  }

  tags = {
    "kubernetes.io/cluster/${local.name}" = ""
    "rancher.user"                        = var.user

  }
}

resource "aws_lb_target_group" "agent-80" {
  count    = local.create_external_nlb
  name     = "${local.name}-agnet-80"
  port     = 80
  protocol = "TCP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    interval            = 10
    timeout             = 6
    path                = "/healthz"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }

  tags = {
    "kubernetes.io/cluster/${local.name}" = ""
    "rancher.user"                        = var.user

  }
}

resource "aws_lb" "server-public-lb" {
  name               = "${local.name}-server-public"
  internal           = false
  load_balancer_type = "network"
  subnets            = local.public_subnets

  tags = {
    "kubernetes.io/cluster/${local.name}" = ""
    "rancher.user"                        = var.user
  }
}

resource "aws_lb_target_group" "server-443" {
  name     = "${local.name}-server-443"
  port     = 443
  protocol = "TCP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    interval            = 10
    timeout             = 6
    path                = "/healthz"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = ""
  }

  stickiness {
    type    = "lb_cookie"
    enabled = false
  }

  tags = {
    "kubernetes.io/cluster/${local.name}" = ""
    "rancher.user"                        = var.user

  }
}

resource "aws_lb_target_group" "server-80" {
  name     = "${local.name}-server-80"
  port     = 80
  protocol = "TCP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    interval            = 10
    timeout             = 6
    path                = "/healthz"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }

  stickiness {
    type    = "lb_cookie"
    enabled = false
  }

  tags = {
    "kubernetes.io/cluster/${local.name}" = ""
    "rancher.user"                        = var.user

  }
}

resource "aws_lb_listener" "server-port_443" {
  load_balancer_arn = aws_lb.server-public-lb.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.server-443.arn
  }
}

resource "aws_lb_listener" "server-port_80" {
  load_balancer_arn = aws_lb.server-public-lb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.server-80.arn
  }
}
