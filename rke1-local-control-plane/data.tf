data "aws_caller_identity" "current" {}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  name   = "default"
}

data "aws_route53_zone" "selected" {
  name         = "${local.domain}."
  private_zone = false
}

data "local_file" "kube_config" {
  filename = local.kube_config
  depends_on = [
    null_resource.rke
  ]
}
