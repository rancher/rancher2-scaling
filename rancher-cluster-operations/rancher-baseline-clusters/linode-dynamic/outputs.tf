output "create_node_reqs" {
  value = var.create_node_reqs
}

output "cred_name" {
  value = module.cloud_credential.name
}

output "nt_names" {
  value = [values(module.cluster_v1)[*].name, values(rancher2_machine_config_v2.this)[*].name]
}

output "cluster_names" {
  value = [values(module.cluster_v1)[*].name, values(rancher2_cluster_v2.cluster_v2)[*].name]
}

# output "kube_config" {
#   value = nonsensitive(module.cluster_v1.kube_config)
# }
