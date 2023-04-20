terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
  }
}

# locals {
#   release_name = "${var.release_prefix}${random_id.index}"
# }

# resource "random_uuid" "index" {
#   byte_length = 2
# }

resource "helm_release" "local_chart" {
  count         = var.local_chart_path ? var.num_charts : 0
  name          = "${var.release_prefix}-${count.index}"
  chart         = var.local_chart_path
  namespace     = var.namespace
  wait          = true
  wait_for_jobs = true
}

resource "helm_release" "remote_chart" {

}
