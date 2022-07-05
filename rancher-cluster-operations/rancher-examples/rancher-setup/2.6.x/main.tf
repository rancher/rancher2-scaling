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
  rancher_version                = "2.6.5"
  rancher_password               = var.rancher_password
  use_new_bootstrap              = true
  rancher_node_count             = var.rancher_node_count
  cattle_prometheus_metrics      = true
}

data "rancher2_cluster_v2" "local" {
  provider = rancher2.admin

  name = "local"
  depends_on = [
    module.install_common
  ]
}

### Create custom Rancher Catalog and install rancher-monitoring for Rancher 2.6.x
### Note: Version 100.1.2+up19.0.3 and above will automatically have the controllers metrics enabled 
### along with a newly created dashboard for them
module "rancher_monitoring" {
  source = "../../../charts/rancher-monitoring"
  providers = {
    rancher2 = rancher2.admin
  }

  use_v2        = true
  rancher_url   = module.install_common.rancher_url
  rancher_token = module.install_common.rancher_token
  charts_branch = "release-v2.6"
  chart_version = "100.1.3+up19.0.3"
  values        = "../../../charts/files/rancher_monitoring_chart_values.yaml"
  cluster_id    = data.rancher2_cluster_v2.local.cluster_v1_id
  project_id    = null
}

module "secret_v2" {
  source = "../../../rancher-secret"
  providers = {
    rancher2 = rancher2.admin
  }

  use_v2      = true
  create_new  = true
  immutable   = true
  type        = "Opaque"
  annotations = { example = "annotation" }
  labels      = { example = "label" }
  cluster_id  = data.rancher2_cluster_v2.local.cluster_v1_id
  name        = "tf-example-secretv2"
  namespace   = "default"
  data        = { example = "my data value" }

  depends_on = [
    data.rancher2_cluster_v2.local
  ]
}
