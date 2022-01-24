output "create_node_reqs" {
  value = var.create_node_reqs
}

output "node_template" {
  value = var.create_node_reqs ? module.shared_node_template[0].node_template : data.rancher2_node_template.existing_nt[0]
}
