variable "node_count" {
  type        = number
  description = "Number of nodes to provision."
  nullable    = false
}

variable "label" {
  type        = string
  description = "Linode's label for display purposes, if not provided a default label will be assigned."
}

variable "image" {
  type        = string
  description = "Linode image ID to deploy all of the linode Disk(s) from."
}

variable "region" {
  type        = string
  description = "Region the linode(s) are deployed."
}

variable "type" {
  type        = string
  description = "The Linode type for each linode."
}

variable "authorized_keys" {
  type        = list(string)
  description = "List of SSH keys that are authorized to access the linode(s). Changing authorized_keys forces the creation of new Linode(s)."
}

variable "authorized_users" {
  type        = list(string)
  description = "List of Linode usernames that are authorized to access the linode(s).  If the usernames have associated SSH keys, the keys will be appended to the root user's ~/.ssh/authorized_keys file automatically. Changing authorized_users forces the creation of new Linode(s)."
}

variable "root_pass" {
  type        = string
  description = "The initial password for the root user account of each linode."
}

variable "group" {
  type        = string
  description = "The display group of the Linode(s)."
}

variable "tags" {
  type        = list(string)
  description = "A list of tags applied to the Linode(s). If provided, var.label will be added to each Linode's tags by default."
}

variable "swap_size" {
  type        = number
  description = "Swap disk size for each Linode."
}

variable "private_ip" {
  type        = bool
  default     = false
  description = "If true, the created Linode(s) will have private networking enabled, allowing use of the 192.168.128.0/17 network within the Linode's region. It can be enabled on an existing Linode but it can't be disabled."
}

variable "shared_ipv4" {

}

variable "stackscript_id" {
  type        = string
  description = "The StackScript to deploy to the Linode(s). If provided, 'image' must also be provided, and must be an Image that is compatible with this StackScript. Changing stackscript_id forces the creation of new Linode(s)."
}

variable "stackscript_data" {
  type        = string
  description = "An object containing responses to any User Defined Fields present in the StackScript being deployed to the Linode(s). Only accepted if 'stackscript_id' is given. The required values depend on the StackScript being deployed. Changing stackscript_data forces the creation of new Linode(s)."
}

variable "backups_enabled" {

}

variable "watchdog_enabled" {

}

variable "booted" {
  type        = bool
  default     = null
  description = "If true, then the instance is kept or converted into in a running state. If false, the instance will be shutdown. If unspecified, the Linode's power status will not be managed by the Provider"
}

variable "interface" {
  type        = list(string)
  description = "A list of network interfaces to be assigned to the Linode on creation. If an explicit config or disk is defined, interfaces must be declared in the config block."
}

variable "disks" {
  type = list(map({
    label      = string
    size       = number
    id         = string
    filesystem = string
  }))
  description = "value"
}
