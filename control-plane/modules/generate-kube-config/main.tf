terraform {
  required_version = ">= 0.14"
  required_providers {
  }
}

locals {
  kubeconfig_path = "${var.kubeconfig_dir}/.${var.identifier_prefix}-tfkubeconfig"
}

resource "local_file" "kubeconfig" {
  content  = var.kubeconfig_content
  filename = local.kubeconfig_path
}
