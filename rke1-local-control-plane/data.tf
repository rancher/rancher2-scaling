data "aws_caller_identity" "current" {
  count = var.infra_provider == "aws" ? 1 : 0
}

data "aws_vpc" "default" {
  count   = var.infra_provider == "aws" ? 1 : 0
  default = true
}

data "aws_route53_zone" "linode" {
  count = var.infra_provider == "linode" ? 1 : 0
  name  = local.domain
}

data "local_file" "kube_config" {
  filename = local.kube_config
  depends_on = [
    null_resource.rke
  ]
}

data "rancher2_setting" "this" {
  for_each = { for setting in var.rancher_settings.* : setting.name => setting.value }
  provider = rancher2.admin

  name = each.key
  depends_on = [
    rancher2_setting.this
  ]
}
