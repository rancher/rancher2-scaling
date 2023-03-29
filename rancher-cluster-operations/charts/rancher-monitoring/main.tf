terraform {
  required_version = ">= 0.14"
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
    }
  }
}

locals {
  default_values = abspath("${path.module}/files/rancher_monitoring_chart_values.yaml")
  values         = try(length(var.values) > 0 ? var.values : local.default_values, local.default_values)
}

resource "rancher2_catalog" "charts_custom" {
  count  = var.use_v2 ? 0 : 1
  name   = "rancher-charts-custom"
  url    = var.charts_repo
  branch = var.charts_branch

  timeouts {
    create = try(var.timeouts.create, null)
    update = try(var.timeouts.update, null)
    delete = try(var.timeouts.delete, null)
  }
}

resource "rancher2_app" "rancher_monitoring" {
  count            = var.use_v2 ? 0 : 1
  catalog_name     = "rancher-charts-custom"
  name             = "rancher-monitoring"
  project_id       = var.project_id
  template_name    = "rancher-monitoring"
  template_version = var.chart_version
  target_namespace = "cattle-monitoring-system"
  values_yaml      = base64encode(file(local.values))

  timeouts {
    create = try(var.timeouts.create, null)
    update = try(var.timeouts.update, null)
    delete = try(var.timeouts.delete, null)
  }

  depends_on = [
    rancher2_catalog.charts_custom
  ]
}

resource "rancher2_catalog_v2" "charts_custom" {
  count = var.use_v2 ? 1 : 0

  cluster_id = var.cluster_id
  name       = "rancher-charts-custom"
  git_repo   = var.charts_repo
  git_branch = var.charts_branch

  timeouts {
    create = try(var.timeouts.create, null)
    update = try(var.timeouts.update, null)
    delete = try(var.timeouts.delete, null)
  }

  provisioner "local-exec" {
    command = <<-EOT
    sleep 10
    EOT
  }
}

resource "rancher2_app_v2" "rancher_monitoring" {
  count = var.use_v2 ? 1 : 0

  cluster_id    = var.cluster_id
  name          = "rancher-monitoring"
  namespace     = "cattle-monitoring-system"
  repo_name     = "rancher-charts-custom"
  chart_name    = "rancher-monitoring"
  chart_version = var.chart_version
  values        = file(local.values)

  timeouts {
    create = try(var.timeouts.create, null)
    update = try(var.timeouts.update, null)
    delete = try(var.timeouts.delete, null)
  }

  depends_on = [
    rancher2_catalog_v2.charts_custom
  ]
}
