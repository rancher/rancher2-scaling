terraform {
  required_version = ">= 0.13"
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
    }
  }
}

locals {
  secret_name = "${var.name_prefix}-${terraform.workspace}"
}

resource "rancher2_secret_v2" "foo" {
  count      = var.secrets_per_workspace
  cluster_id = var.cluster_id
  name       = "${local.secret_name}-${count.index}"
  data       = var.data
}
