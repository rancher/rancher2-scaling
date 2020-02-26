variable "k3s_agents_per_node" {
  type        = number
  description = "The number of k3s agents on each ec2 instance"
}

variable "instances" {
  type = number
}

variable "worker_instance_type" {
  type        = string
  description = "Instance type to use for k3s workers"
}
variable "k3s_endpoint" {}
variable "k3s_token" {}
variable "install_k3s_version" {}
variable "prefix" {}
variable "spot_price" {}
variable "ami_id" {}

variable "consul_store" {}