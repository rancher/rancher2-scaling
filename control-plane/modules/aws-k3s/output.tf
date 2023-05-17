output "rancher_admin_password" {
  value     = local.install_rancher ? local.rancher_password : null
  sensitive = true
}

output "rancher_url" {
  value = try(rancher2_bootstrap.admin[0].url, "N/A")
}

output "rancher_token_id" {
  value = try(rancher2_bootstrap.admin[0].token_id, "N/A")
}

output "rancher_token" {
  value     = try(rancher2_bootstrap.admin[0].token, "N/A")
  sensitive = false
}

output "kube_config" {
  value     = try(data.rancher2_cluster.local[0].kube_config, "N/A")
  sensitive = true
}

output "external_lb_dns_name" {
  value = local.create_agent_nlb > 0 ? aws_lb.agent_lb[0].dns_name : null
}

output "k3s_cluster_secret" {
  value     = local.k3s_cluster_secret
  sensitive = true
}

output "k3s_tls_san" {
  value = local.k3s_tls_san
}

output "use_new_bootstrap" {
  value = var.use_new_bootstrap
}

output "tls_cert_file" {
  value     = local.tls_cert_file
  sensitive = true
}

output "tls_key_file" {
  value     = local.tls_key_file
  sensitive = true
}

output "db_pass" {
  value     = local.db_pass
  sensitive = true
}

output "datastore_endpoint" {
  value     = local.k3s_datastore_endpoint
  sensitive = true
}

output "use_new_monitoring_crd_url" {
  value = local.use_new_monitoring_crd_url
}
