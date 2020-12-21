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

variable "ssh_keys" {
  type        = list
  default     = []
  description = "SSH keys to inject into the EC2 instances"
}

variable "install_k3s_image" {
  type        = string
  default     = "v1.19.3-k3s1"
  description = "k3s image to use during install"
}

variable "k3s_cluster_secret" {
  type        = string
  default     = ""
  description = "k3s cluster secret"
}
