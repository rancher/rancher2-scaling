output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = var.k8s_distribution == "k3s" ? module.db[0].db_instance_availability_zone : null
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = var.k8s_distribution == "k3s" ? nonsensitive(module.k3s[0].datastore_endpoint) : null
}

output "db_password" {
  value = var.k8s_distribution == "k3s" ? nonsensitive(module.k3s[0].db_pass) : null
}

output "external_lb_dns_name" {
  value = var.k8s_distribution == "k3s" ? module.k3s[0].external_lb_dns_name : null
}

output "k3s_cluster_secret" {
  value     = var.k8s_distribution == "k3s" ? nonsensitive(module.k3s[0].k3s_cluster_secret) : null
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
