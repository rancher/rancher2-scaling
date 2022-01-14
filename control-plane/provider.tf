provider "aws" {
  region  = local.aws_region
  profile = "rancher-eng"
}

provider "aws" {
  region  = local.aws_region
  profile = "rancher-eng"
  alias   = "r53"
}

provider "rancher2" {
  alias     = "bootstrap"
  api_url   = "https://${local.name}.${local.domain}"
  insecure  = length(var.byo_certs_bucket_path) > 0 ? true : false
  bootstrap = true
}

provider "rke" {
  debug = true
  # log_file = var.k8s_distribution == "rke1" ? "${path.module}/files/${local.name}_${terraform.workspace}_rke1_logs.txt" : null
}

provider "helm" {
  kubernetes {
    config_path = abspath(module.generate_kube_config.kubeconfig_path)
  }
}

provider "rancher2" {
  alias     = "admin"
  api_url   = var.k8s_distribution == "rke1" ? module.install_common[0].rancher_url : module.k3s[0].rancher_url
  token_key = var.k8s_distribution == "rke1" ? module.install_common[0].rancher_token : module.k3s[0].rancher_token
  insecure  = length(var.byo_certs_bucket_path) > 0 ? true : false
  timeout   = "300s"
}
