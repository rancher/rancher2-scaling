output "rancher_url" {
  value = try(rancher2_bootstrap.admin[0].url, null)
}

output "rancher_token" {
  value     = try(rancher2_bootstrap.admin[0].token, null)
  sensitive = true
}

output "use_new_bootstrap" {
  value = var.use_new_bootstrap
}

# output "rancher_manifest" {
#   value = try(helm_release.rancher[0].manifest, "")
# }

# output "cert_manager_manifest" {
#   value = try(helm_release.cert_manager[0].manifest, "")
# }
