output "rancher_url" {
  value = try(rancher2_bootstrap.admin[0].url, null)
}

output "rancher_token" {
  value     = try(rancher2_bootstrap.admin[0].token, null)
  sensitive = true
}
