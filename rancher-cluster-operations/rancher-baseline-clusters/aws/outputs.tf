output "create_node_reqs" {
  value = var.create_node_reqs
}

output "cred_name" {
  value = module.cloud_credential.name
}

output "nt_names" {
  value = flatten([module.node_template.name, rancher2_machine_config_v2.this[*].name])
}

output "cluster_names" {
  value = local.cluster_names
}
