variable "linode_id" {
  type        = number
  description = "(Required) The ID of the Linode to create this configuration profile under."
}

variable "label" {
  type        = string
  description = "(Required) The Config’s label for display purposes only."
}

variable "booted" {
  type        = optional(bool)
  description = "(Optional) If true, the Linode will be booted into this config. If another config is booted, the Linode will be rebooted into this config. If false, the Linode will be shutdown only if it is currently booted into this config. If undefined, the config will alter the boot status of the Linode."
}

variable "comments" {
  type        = optional(string)
  description = "(Optional) Optional field for arbitrary User comments on this Config."
}

variable "kernel" {
  type        = optional(string, "linode/latest-64bit")
  default     = "linode/latest-64bit"
  description = "(Optional) A Kernel ID to boot a Linode with. (default `linode/latest-64bit`)"
}

variable "memory_limit" {
  type        = optional(number)
  description = "(Optional) The memory limit of the Config. Defaults to the total ram of the Linode."
}

variable "root_device" {
  type        = optional(string)
  description = "(Optional) The root device to boot. (default `/dev/sda`)"
}

variable "run_level" {
  type        = optional(string)
  description = "(Optional) Defines the state of your Linode after booting. (`default`, `single`, `binbash`)"
}

variable "virt_mode" {
  type        = optional(string)
  description = "(Optional) Controls the virtualization mode. (`paravirt`, `fullvirt`)"
}

variable "devices" {
  type = optional(list(map(
    {
      volume_id = optional(string)
      disk_id   = optional(string)
    }
  )))
  description = <<EOF
  (Optional) A list of maps defining the configuration for one or more devices. The SDA-SDH slots, represent the Linux block device nodes for the first 8 disks attached to the Linode.  Each device must be suplied sequentially.  The device can be either a Disk or a Volume identified by `disk_id` or `volume_id`. Only one disk identifier is permitted per slot. Devices mapped from `sde` through `sdh` are unavailable in `"fullvirt"` `virt_mode`.
  * `volume_id` - (Optional) The Volume ID to map to this `device` slot.
  * `disk_id` - (Optional) The Disk ID to map to this `device` slot
  EOF
}

variable "helpers" {
  type = optional(map(
    {
      devtmpfs_automount = optional(bool, true)
      distro             = optional(bool, true)
      modules_dep        = optional(bool, true)
      network            = optional(bool, true)
      updatedb_disabled  = optional(bool, true)
    }
  ))
  description = <<EOF
  (Optional) A map defining the configuration for one or more helpers. The following attributes are available on helpers:
  * `devtmpfs_automount` - (Optional) Populates the /dev directory early during boot without udev. (default `true`)
  * `distro` - (Optional) Helps maintain correct inittab/upstart console device. (default `true`)
  * `modules_dep` - (Optional) Creates a modules dependency file for the Kernel you run. (default `true`)
  * `network` - (Optional) Automatically configures static networking. (default `true`)
  * `updatedb_disabled` - (Optional) Disables updatedb cron job to avoid disk thrashing. (default `true`)
  EOF
}

variable "interfaces" {
  type = optional(list(map(
    {
      purpose      = string
      ipam_address = optional(string)
      label        = optional(string)
    }
  )))
  description = <<EOF
  (Optional) A list of maps defining the configuration for one or more interfaces. The following attributes are available on interface:
  * `purpose` - (Required) The type of interface. (`public`, `vlan`)
  * `ipam_address` - (Optional) This Network Interface’s private IP address in Classless Inter-Domain Routing (CIDR) notation. (e.g. `10.0.0.1/24`)
  * `label` - (Optional) The name of this interface.
  EOF
}
