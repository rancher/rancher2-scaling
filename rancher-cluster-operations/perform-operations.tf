module "rancher-controller-metrics" {
  count  = var.enable_controllers_metrics ? 1 : 0
  source = "./modules/rancher-controller-metrics"
  providers = {
    kubernetes = kubernetes.tfk8s
  }
  rancher_token    = var.rancher_token
  rancher_version  = var.rancher_version
}