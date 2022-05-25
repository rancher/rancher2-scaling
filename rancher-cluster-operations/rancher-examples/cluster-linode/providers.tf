terraform {
  required_version = ">= 1.1.0"
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
    }
    null = {
      source = "hashicorp/null"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

terraform {
  backend "local" {
    path = "rancher.tfstate"
  }
}

provider "rancher2" {
  api_url   = var.rancher_api_url
  token_key = var.rancher_token_key
  insecure  = var.insecure_flag
}

locals {
  rancher_subdomain = split(".", split("//", "${var.rancher_api_url}")[1])[0]
}

resource "random_pet" "this" {
  keepers = {
  }
  prefix = "linode"
  length = 1
}
