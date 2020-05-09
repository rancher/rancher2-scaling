variable "cluster_name" {
  type        = string
  default     = "load-testing"
  description = "Unique identifier used in resource names and tags"
}

variable "cluster_count" {
  type        = number
  description = "Number of clusters to provision"
}

variable "ec2_instances_per_cluster" {
  type        = number
  description = "Number of EC2 instances per cluster"
}

variable "k3s_per_node" {
  type        = number
  description = "The number of k3s agents on each ec2 instance"
}

variable "server_instance_type" {
  type        = string
  description = "Instance type to use for k3s server"
}

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

variable "self_signed" {
  type      = bool
  default   = false
  description = "whether host is using self signed certs"
}
