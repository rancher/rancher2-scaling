output "ips" {
  value = data.linode_instances.this.instances[*].ip_address
}

output "private" {
  value = data.linode_instances.this.instances[*].private_ip_address
}

output "instances" {
  value = data.linode_instances.this.instances[*]
}

output "lb_hostname" {
  value = var.nlb ? module.rancher_nodebalancer[0].hostname : null
}

output "lb_ipv4" {
  value = var.nlb ? module.rancher_nodebalancer[0].ipv4 : null
}

output "lb_ipv6" {
  value = var.nlb ? module.rancher_nodebalancer[0].ipv6 : null
}
