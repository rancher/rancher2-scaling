### install common components for Rancher local clusters (cert-manager + Rancher)
module "install_common" {
  source = "../../../install-common"
  providers = {
    rancher2 = rancher2.bootstrap
  }


  kube_config_path = var.kube_config_path

  subdomain           = local.rancher_subdomain
  domain              = local.rancher_domain
  install_certmanager = true
  install_rancher     = true
  certmanager_version = "1.8.1"

  helm_rancher_chart_values_path = "../../../install-common/files/rancher_chart_values.tftpl"
  letsencrypt_email              = var.letsencrypt_email
  rancher_image                  = "rancher/rancher"
  rancher_version                = var.rancher_version
  rancher_password               = var.rancher_password
  use_new_bootstrap              = false
  rancher_node_count             = var.rancher_node_count
  cattle_prometheus_metrics      = true
}

data "rancher2_cluster" "local" {
  provider = rancher2.admin

  name = "local"
  depends_on = [
    module.install_common
  ]
}

### Create custom Rancher Catalog and install rancher-monitoring for Rancher 2.5.x
module "rancher_monitoring" {
  source = "../../../charts/rancher-monitoring"
  providers = {
    rancher2 = rancher2.admin
  }

  use_v2        = false
  rancher_url   = module.install_common.rancher_url
  rancher_token = module.install_common.rancher_token
  charts_branch = "release-v2.5"
  chart_version = "16.6.1+up16.6.0"
  values        = "../../../charts/files/rancher_monitoring_chart_values.yaml"
  cluster_id    = data.rancher2_cluster.local.id
  project_id    = data.rancher2_cluster.local.default_project_id
}

### Setup and install the custom controller metrics dashboards for rancher-monitoring
module "controller_metrics" {
  source          = "../../../rancher-controller-metrics"
  rancher_token   = module.install_common.rancher_token
  rancher_version = var.rancher_version

  depends_on = [
    module.rancher_monitoring
  ]
}

module "secret" {
  source = "../../../rancher-secret"
  providers = {
    rancher2 = rancher2.admin
  }

  use_v2      = false
  create_new  = true
  annotations = { example = "annotation" }
  labels      = { example = "label" }
  description = "Example description of secret"
  project_id  = data.rancher2_cluster.local.default_project_id
  name        = "tf-example-secret"
  namespace   = "default"
  data        = { example = "my data value" }
}
