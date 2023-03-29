provider "rancher2" {
  bootstrap = false
  api_url   = var.rancher_api_url
  token_key = var.rancher_token_key
  insecure  = true
  timeout   = "300s"
}
