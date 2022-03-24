variable "ami" {
  type        = string
  default     = null
  description = "AMI to use for rke2 server instances"
}

variable "ssh_keys" {
  type        = list(any)
  default     = []
  description = "SSH keys to inject into Rancher instances"
}

variable "ssh_key_path" {
  default     = null
  type        = string
  description = "Path to the ssh_key file to be used for connecting to the nodes"
}

variable "subdomain" {
  default     = null
  type        = string
  description = "Subdomain to host rancher on. Used to create a Route53 record"
}

variable "domain" {
  type    = string
  default = "Used to create a Route53 record"
}

variable "internal_lb" {
  type = bool
}

variable "name" {
  type        = string
  default     = "rancher-scaling"
  description = "Name used for the cluster and various resources, used as a prefix for individual instance names"
}

variable "server_instance_type" {
  type    = string
  default = "m5.large"
}

variable "server_node_count" {
  type        = number
  default     = 1
  description = "Number of server nodes to launch (one of these nodes will be the leader node, should maintain and odd number of server nodes)"
}

variable "server_instance_ssh_user" {
  type        = string
  default     = "ubuntu"
  description = "Username for sshing into instances"
}

variable "install_docker_version" {
  type        = string
  default     = "20.10"
  description = "Version of Docker to install"
}

variable "vpc_id" {
  type        = string
  default     = null
  description = "ID of the VPC to use"
}

variable "subnets" {
  default     = []
  type        = list(any)
  description = "List of subnet ids."
}

variable "extra_server_security_groups" {
  default     = []
  type        = list(any)
  description = "IDs for additional security groups to attach to rke2 server instances"
}

variable "iam_instance_profile" {
  default     = ""
  type        = string
  description = "String that defines the name of the IAM Instance Profile that grants S3 access to the EC2 instances"
}

variable "user" {
  type = string
}

variable "rke2_config" {
  type        = string
  default     = ""
  description = "(Optional) A formatted string that will be appended to the final rke2 config yaml"
}

variable "rke2_version" {
  type        = string
  default     = ""
  description = "Version to use for RKE2 server nodes, defaults to latest on the specified release channel"
}

variable "rke2_channel" {
  type        = string
  default     = "stable"
  description = "Release channel to use for fetching RKE2 download URL, defaults to stable"
}

variable "setup_monitoring_agent" {
  type    = bool
  default = true
}
