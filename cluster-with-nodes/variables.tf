/*
  The k3s agents per node and ec2_instances_per_cluster (and number of clusters) are used together to determine total number of nodes. If you have 3 desired clusters, with 15 k3s agents per node, across 2 instances
*/ 

variable "k3s_agents_per_node" {
  type        = number
  description = "The number of k3s agents on each ec2 instance"
}

variable "ec2_instances_per_cluster" {
  type        = number
  description = "Number of EC2 instances per cluster"
}

variable "server_instance_max_price" {}
variable "server_instance_type" {
  type        = string
  description = "Instance type to use for k3s server"
}

variable "worker_instance_max_price" {}

variable "worker_instance_type" {
  type        = string
  description = "Instance type to use for k3s workers"
}


variable "k3s_server_args" {
  type        = string
  default     = ""
  description = "extra args to pass to k3s server"
}

variable "rancher_api_url" {
  type        = string
  description = "api url for rancher server"
}

variable "rancher_token_key" {
  type        = string
  description = "rancher server API token"
}

variable "k3s_token" {
  type        = string
  description = "k3s token"
}