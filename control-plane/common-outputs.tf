output "k8s_distribtion" {
  value = var.k8s_distribution
}

output "rancher_admin_password" {
  value     = var.rancher_password
  sensitive = true
}

output "rancher_url" {
  value = local.rancher_url
}

output "rancher_token" {
  value     = nonsensitive(local.rancher_token)
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

output "kube_config_path" {
  value = abspath(module.generate_kube_config.kubeconfig_path)
}

output "secrets_encryption" {
  value = var.enable_secrets_encryption
}

output "cattle_prometheus_metrics" {
  value = var.cattle_prometheus_metrics
}