variable "create_node_reqs" {
  type        = bool
  default     = true
  description = "Flag defining if a cloud credential & node template should be created on each tf apply. Useful for scripting purposes"
}

variable "cloud_cred_name" {
  type    = string
  default = null
}

variable "node_template_name" {
  type    = string
  default = null
}

variable "aws_region" {
  type    = string
  default = "us-west-1"
}

variable "aws_access_key" {
  type      = string
  default   = null
  sensitive = true
}

variable "aws_secret_key" {
  type      = string
  default   = null
  sensitive = true
}

variable "aws_ami" {
  type    = string
  default = null
}

variable "iam_instance_profile" {
  type    = string
  default = null
}

variable "install_docker_version" {
  type        = string
  default     = "20.10"
  description = "The version of docker to install. Available docker versions can be found at: https://github.com/rancher/install-docker"
}

variable "security_groups" {
  type        = list(any)
  default     = []
  description = "A list of security group names (EC2-Classic) or IDs (default VPC) to associate with"
}

variable "instance_type" {
  type        = string
  description = "Instance type to use for rke1 server"
}

variable "subnet_id" {
  type    = string
  default = null
}

variable "vpc_id" {
  type    = string
  default = null
}

variable "zone" {
  type    = string
  default = null
}

variable "root_size" {
  type        = string
  default     = "32"
  description = "Size of the storage volume to use in GB"
}

variable "volume_type" {
  type        = string
  default     = "gp2"
  description = "Type of storage volume to use"
}
