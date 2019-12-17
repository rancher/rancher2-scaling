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
