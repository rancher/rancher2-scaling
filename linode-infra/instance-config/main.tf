terraform {
  required_version = ">= 0.13"
  required_providers {
    linode = {
      source = "linode/linode"
    }
  }
}

resource "linode_instance_config" "this" {
  linode_id    = var.linode_id
  label        = var.label
  booted       = var.booted
  comments     = var.comments
  kernel       = var.kernel
  memory_limit = var.memory_limit
  root_device  = var.root_device
  run_level    = var.run_level
  virt_mode    = var.virt_mode

  dynamic "devices" {
    for_each = var.devices
    iterator = device
    content {
      sda = try(device.value.sda, null)
      sdb = try(device.value.sdb, null)
      sdc = try(device.value.sdc, null)
      sdd = try(device.value.sdd, null)
      #  The following Linux block devices are unavailable in "fullvirt" `virt_mode`
      sde = try(device.value.sde, null)
      sdf = try(device.value.sdf, null)
      sdg = try(device.value.sdg, null)
      sdh = try(device.value.sdh, null)
    }
  }

  dynamic "helpers" {
    for_each = var.helpers
    iterator = helper
    content {
      devtmpfs_automount = try(helper.devtmpfs_automount, null)
      distro             = try(helper.distro, null)
      modules_dep        = try(helper.modules_dep, null)
      network            = try(helper.network, null)
      updatedb_disabled  = try(helper.updatedb_disabled, null)
    }
  }

  # Public networking on eth0
  dynamic "interface" {
    for_each = var.interfaces
    iterator = interface
    content {
      purpose      = try(interface.value.purpose, null)
      ipam_address = try(interface.value.ipam_address, null)
      label        = try(interface.value.label, null)
    }
  }
}
