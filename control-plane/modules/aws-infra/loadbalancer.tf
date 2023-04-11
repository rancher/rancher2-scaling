resource "aws_lb" "server_lb" {
  count              = local.create_internal_nlb
  name               = local.internal_lb_name
  internal           = true
  load_balancer_type = "network"
  subnets            = local.private_subnets

  tags = {
    for tag in local.custom_tags : "${tag.key}" => "${tag.value}"
  }

}

resource "aws_lb_listener" "server_port_6443" {
  count             = local.create_internal_nlb
  load_balancer_arn = aws_lb.server_lb[0].arn
  port              = "6443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.server-6443[0].arn
  }
}

resource "aws_lb_target_group" "server-6443" {
  count    = local.create_internal_nlb
  name     = "${local.name}-server-6443"
  port     = 6443
  protocol = "TCP"
  vpc_id   = data.aws_vpc.default.id
}

resource "aws_lb" "lb" {
  count              = local.create_external_nlb
  name               = local.agent_external_lb_name
  internal           = false
  load_balancer_type = "network"
  subnets            = local.public_subnets

  tags = {
    for tag in local.custom_tags : "${tag.key}" => "${tag.value}"
  }
}

resource "aws_lb_listener" "port_443" {
  count             = local.create_external_nlb
  load_balancer_arn = aws_lb.lb.0.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.agent-443[0].arn
  }
}

resource "aws_lb_listener" "port_80" {
  count             = local.create_external_nlb
  load_balancer_arn = aws_lb.lb.0.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.agent-80[0].arn
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
    type    = "source_ip"
    enabled = false
  }

  tags = {
    for tag in local.custom_tags : "${tag.key}" => "${tag.value}"
  }
}

resource "aws_lb_target_group" "agent-80" {
  count    = local.create_external_nlb
  name     = "${local.name}-agent-80"
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
    for tag in local.custom_tags : "${tag.key}" => "${tag.value}"
  }
}

resource "aws_lb" "server-public-lb" {
  count              = local.create_public_nlb
  name               = local.external_lb_name
  internal           = false
  load_balancer_type = "network"
  subnets            = local.public_subnets

  tags = {
    for tag in local.custom_tags : "${tag.key}" => "${tag.value}"
  }
}

resource "aws_lb_target_group" "server-443" {
  count    = local.create_public_nlb
  name     = "${local.name}-443"
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
    type    = "source_ip"
    enabled = false
  }

  tags = {
    for tag in local.custom_tags : "${tag.key}" => "${tag.value}"
  }
}

resource "aws_lb_target_group" "server-80" {
  count    = local.create_public_nlb
  name     = "${local.name}-80"
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
    type    = "source_ip"
    enabled = false
  }

  tags = {
    for tag in local.custom_tags : "${tag.key}" => "${tag.value}"
  }
}

resource "aws_lb_listener" "server-port_443" {
  count             = local.create_public_nlb
  load_balancer_arn = aws_lb.server-public-lb[0].arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.server-443[0].arn
  }
}

resource "aws_lb_listener" "server-port_80" {
  count             = local.create_public_nlb
  load_balancer_arn = aws_lb.server-public-lb[0].arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.server-80[0].arn
  }
}
