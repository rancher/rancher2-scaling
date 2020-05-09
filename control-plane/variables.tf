variable "rancher_version" {
  default     = "2.3.2"
  type        = string
  description = "rancher version to provision"
}

variable "rancher_instance_type" {
  default     = "m5.xlarge"
  type        = string
  description = "instance type used for the rancher servers"
}

variable "db_name" {
  default = "rancher"
  type    = string
}

variable "db_engine" {
  default = "mariadb"
  type    = string
}

variable "db_engine_version" {
  default = "10.3"
  type    = string
}

variable "db_instance_class" {
  default = "db.m5.xlarge"
  type    = string
}

variable "db_port" {
  default = 3306
  type    = number
}

variable "db_allocated_storage" {
  default = 100
  type    = number
}

variable "db_storage_encrypted" {
  default = false
  type    = bool
}

variable "db_storage_type" {
  default = "io1"
  type    = string
}

variable "db_iops" {
  default = 2500
  type    = number
}

variable "db_username" {
  default = "rancher"
  type    = "string"
}

variable "db_password" {
  default = "rancher12345"
  type    = string
}

variable "ssh_keys" {
  type        = list
  default     = []
  description = "SSH keys to inject into Rancher instances"
}

variable "rancher_image" {
  type    = string
  default = "rancher/rancher"
}

variable "rancher_image_tag" {
  type    = string
  default = "master-head"
}

variable "rancher_node_count" {
  type    = number
  default = 1
}

variable "install_k3s_version" {
  default     = "1.0.0"
  type        = string
  description = "Version of K3S to install"
}

variable "rancher_password" {
  type        = string
  default     = ""
  description = "Password to set for admin user during bootstrap of Rancher Server, if not set random password will be generated"
}

variable "random_prefix" {
  type        = string
  default     = "rancher"
  description = "Prefix to be used with random name generation"
}

variable "server_k3s_exec" {
  default     = null
  type        = string
  description = "exec args to pass to k3s server"
}

variable "self_signed" {
  default     = false
  type        = bool
  description = "whether to use self_signed certs"
}
