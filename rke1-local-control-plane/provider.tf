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
  insecure  = false
  bootstrap = true
}

provider "helm" {
  kubernetes {
    config_path = abspath(local.kube_config)
  }
}

provider "rancher2" {
  alias     = "admin"
  api_url   = local.rancher_url
  token_key = local.rancher_token
  insecure  = false
  timeout   = "300s"
}
