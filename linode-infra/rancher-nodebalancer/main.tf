terraform {
  required_version = ">= 0.13"
  required_providers {
    linode = {
      source = "linode/linode"
    }
  }
}

locals {
  ports = [80, 443, 6443]
}

resource "linode_nodebalancer" "this" {
  label                = var.label
  region               = var.region
  client_conn_throttle = 0
  tags                 = var.tags
}

resource "linode_nodebalancer_config" "this" {
  count = length(local.ports)

  nodebalancer_id = linode_nodebalancer.this.id
  port            = local.ports[count.index]
  protocol        = "tcp"
  check           = "connection"
  check_timeout   = 6
  check_path      = "/healthz"
  stickiness      = "table"
}

### Adding linodes to nodebalancer
resource "linode_nodebalancer_node" "nlb_80" {
  count           = var.node_count
  nodebalancer_id = linode_nodebalancer.this.id
  config_id       = linode_nodebalancer_config.this[0].id
  label           = substr("${var.linodes[count.index].label}-${local.ports[0]}", 0, 32)
  address         = "${var.linodes[count.index].private_ip_address}:${local.ports[0]}"
  mode            = "accept"
}

resource "linode_nodebalancer_node" "nlb_443" {
  count           = var.node_count
  nodebalancer_id = linode_nodebalancer.this.id
  config_id       = linode_nodebalancer_config.this[1].id
  label           = substr("${var.linodes[count.index].label}-${local.ports[1]}", 0, 32)
  address         = "${var.linodes[count.index].private_ip_address}:${local.ports[1]}"
  mode            = "accept"
}

resource "linode_nodebalancer_node" "nlb_6443" {
  count           = var.node_count
  nodebalancer_id = linode_nodebalancer.this.id
  config_id       = linode_nodebalancer_config.this[2].id
  label           = substr("${var.linodes[count.index].label}-${local.ports[2]}", 0, 32)
  address         = "${var.linodes[count.index].private_ip_address}:${local.ports[2]}"
  mode            = "accept"
}
### End adding linodes to nodebalancer

output "id" {
  value = linode_nodebalancer.this.id
}

output "hostname" {
  value = linode_nodebalancer.this.hostname
}

output "ipv4" {
  value = linode_nodebalancer.this.ipv4
}

output "ipv6" {
  value = linode_nodebalancer.this.ipv6
}

output "created" {
  value = linode_nodebalancer.this.created
}

output "updated" {
  value = linode_nodebalancer.this.updated
}

output "transfer" {
  value = linode_nodebalancer.this.transfer
}
