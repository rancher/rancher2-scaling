/*
output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = var.k8s_distribution == "k3s" ? module.db[0].this_db_instance_address : null
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = var.k8s_distribution == "k3s" ? module.db[0].this_db_instance_arn : null
}
*/

output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = var.k8s_distribution == "k3s" ? module.db[0].db_instance_availability_zone : null
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = var.k8s_distribution == "k3s" ? module.db[0].db_instance_endpoint : null
}

/*
output "db_instance_id" {
  description = "The RDS instance ID"
  value       = var.k8s_distribution == "k3s" ? module.db[0].this_db_instance_id : null
}
*/

output "k8s_distribtion" {
  value = var.k8s_distribution
}

output "rancher_admin_password" {
  value     = var.rancher_password
  sensitive = true
}

output "rancher_url" {
  value = var.k8s_distribution == "k3s" ? module.k3s[0].rancher_url : module.install_common[0].rancher_url
}

output "rancher_token" {
  value     = var.k8s_distribution == "k3s" ? var.sensitive_token ? null : nonsensitive(module.k3s[0].rancher_token) : var.sensitive_token ? null : nonsensitive(module.install_common[0].rancher_token)
  sensitive = false
}

output "external_lb_dns_name" {
  value = var.k8s_distribution == "k3s" ? module.k3s[0].external_lb_dns_name : null
}

output "k3s_cluster_secret" {
  value     = var.k8s_distribution == "k3s" ? module.k3s[0].k3s_cluster_secret : null
  sensitive = true
}

output "k3s_tls_san" {
  value = var.k8s_distribution == "k3s" ? module.k3s[0].k3s_tls_san : null
}

output "db_engine_version" {
  value = var.k8s_distribution == "k3s" ? var.db_engine_version : null
}

output "db_skip_final_snapshot" {
  value = var.k8s_distribution == "k3s" ? var.db_skip_final_snapshot : null
}

output "server_k3s_exec" {
  value = var.k8s_distribution == "k3s" ? var.server_k3s_exec : null
}

output "install_rancher" {
  value = var.install_rancher
}

output "install_certmanager" {
  value = var.install_certmanager
}

output "install_monitoring" {
  value = var.install_monitoring
}

output "certmanager_version" {
  value = var.certmanager_version
}

output "tls_cert_file" {
  value     = var.tls_cert_file
  sensitive = true
}

output "tls_key_file" {
  value     = var.tls_key_file
  sensitive = true
}

output "rancher_charts_repo" {
  value = var.install_monitoring ? var.rancher_charts_repo : null
}

output "rancher_charts_branch" {
  value = var.install_monitoring ? var.rancher_charts_branch : null
}

output "rancher_version" {
  value = var.rancher_version
}

output "use_new_bootstrap" {
  value = local.use_new_bootstrap
}

# output "rke_cluster_yaml" {
#   value     = var.k8s_distribution == "rke1" ? nonsensitive(module.rke1[0].cluster_yaml) : null
#   sensitive = false
# }
