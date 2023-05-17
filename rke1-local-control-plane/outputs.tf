output "rancher_admin_password" {
  value     = var.rancher_password
  sensitive = true
}

output "rancher_url" {
  value = local.rancher_url
}

output "rancher_token" {
  value     = try(nonsensitive(local.rancher_token), "")
  sensitive = false
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

output "kube_config_path" {
  value = abspath(local.kube_config)
}

output "secrets_encryption" {
  value = var.enable_secrets_encryption
}

output "cattle_prometheus_metrics" {
  value = var.cattle_prometheus_metrics
}

output "name" {
  value = local.name
}

output "nodes_ids" {
  # value = module.aws_infra[0].nodes_ids
  value = local.nodes_info[*].id
}

output "nodes_public_ips" {
  # value = module.aws_infra[0].nodes_public_ips
  value = local.nodes_info[*].public_address
}

output "nodes_private_ips" {
  # value = module.aws_infra[0].nodes_private_ips
  value = local.nodes_info[*].private_address
}

output "nodes_info" {
  value = local.nodes_info
}

output "rancher2_settings" {
  value = data.rancher2_setting.this.*
}
