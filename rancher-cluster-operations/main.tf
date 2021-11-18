terraform {
  required_version = ">= 0.14"
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

terraform {
  backend "local" {
    path = "rancher.tfstate"
  }
}

provider "rancher2" {
  alias     = "admin"
  api_url   = "${var.rancher_url}"
  token_key = "${var.rancher_token}"
}

provider "kubernetes" {
  alias = "tfk8s"
  config_path    = "${var.kube_config_path}"
  config_context = "${var.cluster_context}"
}