variable "linode_id" {
  type        = number
  description = "(Required) The ID of the Linode to create this Disk under."
}

variable "label" {
  type        = string
  description = "(Required) The Disk's label for display purposes only."
}

variable "size" {
  type        = string
  description = "(Required) The size of the Disk in MB. NOTE: Resizing a disk will trigger a Linode reboot."
}

variable "authorized_keys" {
  type        = optional(list(string))
  description = "(Optional) A list of public SSH keys that will be automatically appended to the root user’s ~/.ssh/authorized_keys file when deploying from an Image."
}

variable "authorized_users" {
  type        = optional(list(string))
  description = "(Optional) A list of usernames. If the usernames have associated SSH keys, the keys will be appended to the root user’s ~/.ssh/authorized_keys file."
}

variable "filesystem" {
  type        = string
  description = "(Optional) The filesystem of this disk. (`raw`, `swap`, `ext3`, `ext4`, `initrd`)"
}

variable "image" {
  type        = string
  description = "(Optional) An Image ID to deploy the Linode Disk from."
}

variable "root_pass" {
  type        = string
  description = "(Optional) The root user’s password on a newly-created Linode Disk when deploying from an Image."
}

variable "stackscript_data" {
  type        = string
  description = "(Optional) An object containing responses to any User Defined Fields present in the StackScript being deployed to this Disk. Only accepted if `stackscript_id` is given."
}

variable "stackscript_id" {
  type        = string
  description = "(Optional) A StackScript ID that will cause the referenced StackScript to be run during deployment of this Disk."
}
