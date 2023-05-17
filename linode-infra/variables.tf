variable "random_prefix" {
  type        = string
  description = "Prefix to be used with random name generation"
}

variable "linode_token" {
  type        = string
  description = "Linode API token"
  nullable    = false
  sensitive   = true
}

variable "subdomain" {
  type        = string
  default     = null
  description = "The subdomain to create a linode_domain_record on. Will be added to tags and labels, etc"
  nullable    = true
}

variable "domain" {
  type        = string
  description = "The domain to pull data from via a linode_domain data source"
  nullable    = false
}

variable "nlb" {
  type    = bool
  default = true
}

variable "node_count" {
  type        = number
  default     = 1
  description = "Number of nodes to provision."
  nullable    = false
}

variable "tags" {
  type        = list(string)
  default     = []
  description = "A list of tags applied to the Linode(s). If provided, var.label will be added to each Linode's tags by default."
}

variable "label" {
  type        = string
  default     = null
  description = "Linode's label for display purposes, if not provided a default label will be assigned based on either var.subdomain or a randomized identifier."
}

variable "image" {
  type        = string
  default     = "linode/ubuntu18.04"
  description = "Linode image ID to deploy all of the linode Disk(s) from."
  nullable    = false
}

variable "region" {
  type        = string
  default     = "us-east"
  description = "Region the linode(s) are deployed."
  nullable    = false
}

variable "instance_type" {
  type        = string
  default     = "g6-dedicated-4"
  description = "The Linode type for each linode."
  nullable    = false
}

variable "authorized_keys" {
  type        = list(string)
  default     = null
  description = "List of SSH keys that are authorized to access the linode(s). Changing authorized_keys forces the creation of new Linode(s)."
}

variable "authorized_users" {
  type        = list(string)
  default     = null
  description = <<-EOT
  List of Linode usernames that are authorized to access the linode(s).
  If the usernames have associated SSH keys, the keys will be appended to the root user's ~/.ssh/authorized_keys file automatically.
  Changing authorized_users forces the creation of new Linode(s).
  EOT
}

variable "ssh_key_path" {
  default     = null
  type        = string
  description = "Path to the private SSH key file to be used for connecting to the node(s)"
}

variable "root_pass" {
  type        = string
  default     = null
  description = "The initial password for the root user account of each linode."
}

variable "group" {
  type        = string
  default     = "terraform-linode"
  description = "The display group of the Linode(s)."
}

variable "swap_size" {
  type        = number
  default     = 512
  description = "When deploying from an Image, this field is optional with a Linode API default of 512mb, otherwise it is ignored. This is used to set the swap disk size for the newly-created Linode."
}

variable "private_ip" {
  type        = bool
  default     = false
  description = "If true, the created Linode(s) will have private networking enabled, allowing use of the 192.168.128.0/17 network within the Linode's region. It can be enabled on an existing Linode but it can't be disabled."
}

variable "shared_ipv4" {
  type        = list(string)
  default     = null
  description = "A set of IPv4 addresses to be shared with the Instance. These IP addresses can be both private and public, but must be in the same region as the instance."
}

variable "stackscript_id" {
  type        = string
  default     = null
  description = "The StackScript to deploy to the newly created Linode. If provided, 'image' must also be provided, and must be an Image that is compatible with this StackScript. This value can not be imported. Changing stackscript_id forces the creation of a new Linode Instance."
}

variable "stackscript_data" {
  type        = map(any)
  default     = null
  description = "An object containing responses to any User Defined Fields present in the StackScript being deployed to this Linode. Only accepted if 'stackscript_id' is given. The required values depend on the StackScript being deployed. This value can not be imported. Changing stackscript_data forces the creation of a new Linode Instance."
}
