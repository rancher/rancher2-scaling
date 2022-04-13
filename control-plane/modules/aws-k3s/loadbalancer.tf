### used in order to keep the k3s.yaml (kubeconfig) secured behind
### this private NLB so that it is only accessible from within the cluster itself
# resource "aws_lb" "server_lb" {
#   name               = "${local.name}-server-int"
#   internal           = true
#   load_balancer_type = "network"
#   subnets            = local.private_subnets

#   tags = {
#     "kubernetes.io/cluster/${local.name}" = ""
#     "rancher.user"                        = var.user
#   }

# }

### previously set to private NLB in order to secure access to the k8s api
### so that it was only accessible from within the cluster itself
resource "aws_lb_listener" "server_port_6443" {
  load_balancer_arn = aws_lb.server-public-lb.arn
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


resource "aws_lb" "agent_lb" {
  count              = local.create_agent_nlb
  name               = "${local.name}-agent-ext"
  internal           = false
  load_balancer_type = "network"
  subnets            = local.public_subnets

  tags = {
    "kubernetes.io/cluster/${local.name}" = ""
    "rancher.user"                        = var.user
  }
}

resource "aws_lb_listener" "port_443" {
  count             = local.create_agent_nlb
  load_balancer_arn = aws_lb.agent_lb[0].arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.agent-443[0].arn
  }
}

resource "aws_lb_listener" "port_80" {
  count             = local.create_agent_nlb
  load_balancer_arn = aws_lb.agent_lb[0].arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.agent-80[0].arn
  }
}

resource "aws_lb_target_group" "agent-443" {
  count    = local.create_agent_nlb
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
    "kubernetes.io/cluster/${local.name}" = ""
    "rancher.user"                        = var.user

  }
}

resource "aws_lb_target_group" "agent-80" {
  count    = local.create_agent_nlb
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
    "kubernetes.io/cluster/${local.name}" = ""
    "rancher.user"                        = var.user

  }
}

resource "aws_lb" "server-public-lb" {
  name               = local.name
  internal           = false
  load_balancer_type = "network"
  subnets            = local.public_subnets

  tags = {
    "kubernetes.io/cluster/${local.name}" = ""
    "rancher.user"                        = var.user
  }
}

resource "aws_lb_target_group" "server-443" {
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
    "kubernetes.io/cluster/${local.name}" = ""
    "rancher.user"                        = var.user

  }
}

resource "aws_lb_target_group" "server-80" {
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
