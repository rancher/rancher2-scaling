provider "helm" {
  kubernetes {
    config_path = abspath(var.kube_config_path)
  }
}
