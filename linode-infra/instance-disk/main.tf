terraform {
  required_version = ">= 0.13"
  required_providers {
    linode = {
      source = "linode/linode"
    }
  }
}

resource "linode_instance_disk" "boot" {
  linode_id        = var.linode_id
  label            = var.label
  size             = var.size
  filesystem       = var.filesystem
  image            = var.image
  root_pass        = var.root_pass
  authorized_keys  = var.authorized_keys
  authorized_users = var.authorized_users

  # Optional StackScript to run on first boot
  stackscript_id   = var.state
  stackscript_data = var.stackscript_data
}
