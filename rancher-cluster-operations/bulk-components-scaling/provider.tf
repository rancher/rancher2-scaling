provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "rancher2" {
  bootstrap = false
  api_url   = var.rancher_api_url
  token_key = var.rancher_token_key
  insecure  = true
  timeout   = "300s"
}
