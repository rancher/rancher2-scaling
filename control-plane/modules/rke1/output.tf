output "kube_config" {
  value = rke_cluster.local.kube_config_yaml
}

output "cluster_yaml" {
  value = rke_cluster.local.rke_cluster_yaml
}

output "api_server_url" {
  value = rke_cluster.local.api_server_url
}

output "client_cert" {
  value     = rke_cluster.local.client_cert
  sensitive = false
}

output "client_key" {
  value     = rke_cluster.local.client_key
  sensitive = false
}

output "ca_crt" {
  value     = rke_cluster.local.ca_crt
  sensitive = false
}

output "rke_cluster" {
  value     = rke_cluster.local
  sensitive = false
}
