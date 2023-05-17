terraform {
  required_version = ">= 0.14"
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

locals {
  token_id = split(":", var.rancher_token)[0]
}

# resource "kubernetes_secret" "bearer_token_secret" {
#   metadata {
#     name      = "secret-${local.token_id}"
#     namespace = "cattle-system"
#   }

#   data = {
#     token = "${var.rancher_token}"
#   }
# }

# resource "kubernetes_manifest" "rancher_service_monitor" {
#   manifest = yamldecode(templatefile(
#     "${path.module}/files/rancher-service-monitor.yaml",
#     { secret_name = "${kubernetes_secret.bearer_token_secret.metadata[0].name}", rancher_version = "${var.rancher_version}" }
#   ))

#   timeouts {
#     create = "4m"
#     update = "4m"
#     delete = "15s"
#   }
# }

resource "kubernetes_config_map" "rancher_controllers" {
  metadata {
    annotations = {
      "meta.helm.sh/release-name"      = "rancher-monitoring-${count.index}"
      "meta.helm.sh/release-namespace" = "cattle-monitoring-system"
    }
    labels = {
      "app"                          = "rancher-monitoring-grafana-${count.index}"
      "grafana_dashboard"            = "1-${count.index}"
      "heritage"                     = "terraform"
      "app.kubernetes.io/managed-by" = "terraform"
    }
    name      = "rancher-custom-dashboards-controllers-${count.index}"
    namespace = "cattle-dashboards"
  }

  data = {
    "rancher-controllers-dashboard.json" = "${file("${path.module}/files/controllers-dashboard.json")}"
  }
}
