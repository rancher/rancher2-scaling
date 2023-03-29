output "external_lb_dns_name" {
  value = local.create_external_nlb > 0 ? aws_lb.lb.0.dns_name : null
}

output "nodes_ids" {
  value = data.aws_instances.nodes.ids
}

output "nodes_private_ips" {
  value = data.aws_instances.nodes.private_ips
}

output "nodes_public_ips" {
  value = data.aws_instances.nodes.public_ips
}
