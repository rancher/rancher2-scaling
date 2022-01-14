output "rancher_url" {
  value = rancher2_bootstrap.admin[0].url
}

output "rancher_token" {
  value     = rancher2_bootstrap.admin[0].token
  sensitive = true
}
