variable "cluster_name" {
  type        = string
  default     = "load-testing"
  description = "Unique identifier used in resource names and tags"
}

variable "cluster_count" {
  type        = number
  description = "Number of clusters to provision"
}

variable "aws_region" {
  type    = string
  default = "us-west-1"
}

variable "security_groups" {
  type        = list(any)
  default     = []
  description = "A list of security group names (EC2-Classic) or IDs (default VPC) to associate with"
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
  type        = list(any)
  default     = []
  description = "SSH keys to inject into the EC2 instances"
}

variable "install_k3s_image" {
  type        = string
  default     = "v1.19.3-k3s1"
  description = "k3s image to use during install (container image tag with the 'v')"
}

variable "k3d_version" {
  type        = string
  default     = "v3.4.0"
  description = "k3d version to use during cluster create (release tag with the 'v')"
}

variable "k3s_cluster_secret" {
  type        = string
  default     = ""
  description = "k3s cluster secret"
}

variable "insecure_flag" {
  type        = bool
  default     = false
  description = "Flag used to determine if Rancher is using self-signed invalid certs (using a private CA)"
}

variable "cluster_labels" {
  type        = map(any)
  default     = {}
  description = "Labels to add to each provisioned cluster"
}