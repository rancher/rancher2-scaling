output "rancher_admin_password" {
  value     = local.install_rancher ? local.rancher_password : null
  sensitive = true
}

output "rancher_url" {
  value = rancher2_bootstrap.admin[0].url
}

output "rancher_token" {
  value     = rancher2_bootstrap.admin[0].token
  sensitive = false
}

output "external_lb_dns_name" {
  value = local.create_external_nlb > 0 ? aws_lb.lb.0.dns_name : null
}

output "k3s_cluster_secret" {
  value     = local.k3s_cluster_secret
  sensitive = true
}

output "k3s_tls_san" {
  value     = local.k3s_tls_san
}

output "use_new_bootstrap" {
  value     = local.use_new_bootstrap
}

output "tls_cert_file" {
  value     = local.tls_cert_file
  sensitive = true
}

output "tls_key_file" {
  value     = local.tls_key_file
  sensitive = true
}
