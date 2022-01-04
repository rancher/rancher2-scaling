variable "cluster_name" {
  type        = string
  default     = "load-testing"
  description = "Unique identifier appended to the Rancher url subdomain"
}

variable "node_pool_count" {
  type        = number
  default     = 3
  description = "Number of node pools to create"
}

variable "nodes_per_pool" {
  type        = number
  default     = 1
  description = "Number of nodes to create per node pool"
}

variable "create_node_reqs" {
  type        = bool
  default     = true
  description = "Flag defining if a cloud credential & node template should be created on tf apply. Useful for scripting purposes"
}

variable "existing_node_template" {
  type        = string
  default     = null
  description = "(Optional) Name of an existing node template to use. Only use this if create_node_reqs is false."
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

variable "server_instance_type" {
  type        = string
  description = "Instance type to use for rke1 server"
}

variable "volume_size" {
  type        = string
  default     = "32"
  description = "Size of the storage volume to use in GB"
}

variable "volume_type" {
  type        = string
  default     = "gp2"
  description = "Type of storage volume to use"
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
