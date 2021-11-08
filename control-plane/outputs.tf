output "identity" {
  value = local.identifier
}
/*
output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = module.db.this_db_instance_address
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = module.db.this_db_instance_arn
}
*/

output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = module.db.db_instance_availability_zone
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.db.db_instance_endpoint
}

/*
output "db_instance_id" {
  description = "The RDS instance ID"
  value       = module.db.this_db_instance_id
}
*/

output "rancher_admin_password" {
  value     = module.k3s.rancher_admin_password
  sensitive = true
}

output "rancher_url" {
  value = module.k3s.rancher_url
}

output "rancher_token" {
  value     = var.sensitive_token ? null : nonsensitive(module.k3s.rancher_token)
  sensitive = false
}

output "external_lb_dns_name" {
  value = module.k3s.external_lb_dns_name
}

output "k3s_cluster_secret" {
  value     = module.k3s.k3s_cluster_secret
  sensitive = true
}

output "k3s_tls_san" {
  value = module.k3s.k3s_tls_san
}

output "db_engine_version" {
  value = var.db_engine_version
}

output "db_skip_final_snapshot" {
  value = var.db_skip_final_snapshot
}

output "server_k3s_exec" {
  value = var.server_k3s_exec
}

output "install_certmanager" {
  value = var.install_certmanager
}

output "certmanager_version" {
  value = var.certmanager_version
}

output "tls_cert_file" {
  value     = module.k3s.tls_cert_file
  sensitive = true
}

output "tls_key_file" {
  value     = module.k3s.tls_key_file
  sensitive = true
}

output "random_prefix" {
  value = var.random_prefix
}

output "rancher_chart_tag" {
  value = var.rancher_chart_tag
}

output "rancher_version" {
  value = var.rancher_version
}

output "use_new_bootstrap" {
  value = module.k3s.use_new_bootstrap
}
