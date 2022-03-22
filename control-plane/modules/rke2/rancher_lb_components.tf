resource "aws_lb_target_group" "server_443" {
  name     = "${var.name}-rke2-443"
  port     = 443
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 10
    port                = 80
    protocol            = "TCP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  stickiness {
    type    = "source_ip"
    enabled = false
  }

  tags = local.tags
}

resource "aws_lb_target_group" "server_80" {
  name     = "${var.name}-rke2-80"
  port     = 80
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 10
    port                = 80
    protocol            = "TCP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  stickiness {
    type    = "source_ip"
    enabled = false
  }

  tags = local.tags
}

resource "aws_lb_listener" "server-port_443" {
  load_balancer_arn = module.aws_infra_rke2.lb_arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.server_443.arn
  }
}

resource "aws_lb_listener" "server-port_80" {
  load_balancer_arn = module.aws_infra_rke2.lb_arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.server_80.arn
  }
}
