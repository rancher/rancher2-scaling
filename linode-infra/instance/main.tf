terraform {
  required_version = ">= 0.13"
  required_providers {
    linode = {
      source = "linode/linode"
    }
  }
}

locals {

}

resource "linode_instance" "this" {
  count = var.node_count

  label = "${var.label}-${count.index}"
  tags  = distinct(concat(var.tags, ["${var.label}"]))
  group = var.group

  image  = var.image
  region = var.region
  type   = var.type

  authorized_keys  = var.authorized_keys
  authorized_users = var.authorized_users
  root_pass        = var.root_pass

  private_ip  = var.private_ip
  shared_ipv4 = var.shared_ipv4

  swap_size        = var.swap_size
  resize_disk      = var.resize_disk
  backups_enabled  = var.backups_enabled
  watchdog_enabled = var.watchdog_enabled
  booted           = var.booted

  dynamic "alerts" {
    for_each = var.alerts
    iterator = alert
    content {
      cpu            = alert.value.cpu
      network_in     = alert.value.network_in
      network_out    = alert.value.network_out
      transfer_quota = alert.value.transfer_quota
      io             = alert.value.io
    }
  }

  dynamic "backups" {
    for_each = var.backups
    iterator = backup
    content {
      enabled = backup.value.enabled
      schedule {
        day    = backup.value.schedule.day
        window = backup.value.schedule.window
      }
    }
  }

  dynamic "interface" {
    for_each = toset(var.interfaces)
    content {
      purpose      = interface.value.purpose
      label        = interface.label.purpose
      ipam_address = interface.ipam_address.purpose
    }
  }

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}
