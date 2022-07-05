terraform {
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
    }
    helm = {
      source = "hashicorp/helm"
    }
    null = {
      source = "hashicorp/null"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "rancher2" {
  alias     = "bootstrap"
  api_url   = var.rancher_api_url
  insecure  = false
  bootstrap = true
}

provider "rancher2" {
  alias     = "admin"
  api_url   = module.install_common.rancher_url
  token_key = module.install_common.rancher_token
  timeout   = "300s"
}

provider "helm" {
  kubernetes {
    config_path = abspath(var.kube_config_path)
  }
}

provider "kubernetes" {
  config_path    = abspath(var.kube_config_path)
  config_context = var.kube_config_context
}

locals {
  rancher_CN             = split("//", "${var.rancher_api_url}")[1]
  rancher_url_components = split(".", local.rancher_CN)
  rancher_subdomain      = local.rancher_url_components[0]
  rancher_domain         = "${local.rancher_url_components[1]}.${local.rancher_url_components[2]}.${local.rancher_url_components[3]}"
}
