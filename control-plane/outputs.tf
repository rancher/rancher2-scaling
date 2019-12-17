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
  value       = module.db.this_db_instance_availability_zone
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.db.this_db_instance_endpoint
}

/*
output "db_instance_id" {
  description = "The RDS instance ID"
  value       = module.db.this_db_instance_id
}
*/

output "rancher_admin_password" {
  value = module.k3s.rancher_admin_password
}

output "rancher_url" {
  value = module.k3s.rancher_url
}

output "rancher_token" {
  value     = module.k3s.rancher_token
  sensitive = true
}

output "external_lb_dns_name" {
  value = module.k3s.external_lb_dns_name
}

output "k3s_cluster_secret" {
  value = module.k3s.k3s_cluster_secret
}

