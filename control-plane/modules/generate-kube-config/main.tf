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

# resource "null_resource" "save_kubeconfig" {
#   provisioner "local-exec" {
#     command = "echo \"${var.kubeconfig_content}\" > ${local.kubeconfig_path}-copy"
#   }
# }
