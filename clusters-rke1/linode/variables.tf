variable "name_suffix" {
  type        = string
  default     = null
  description = "(Optional) suffix to append to your cloud credential, node template and node pool names"
}

variable "cluster_name" {
  type        = string
  default     = "load-testing"
  description = "Unique cluster identifier appended to the Rancher url subdomain"
}

variable "cluster_labels" {
  type        = map(any)
  default     = {}
  description = "Labels to add to each provisioned cluster"
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

variable "region" {
  type        = string
  default     = "us-west-1"
  description = "Cloud provider-specific region string. Defaults to an AWS-specific region"
}

variable "linode_token" {
  type      = string
  default   = null
  sensitive = true
}

variable "image" {
  type        = string
  default     = "linode/ubuntu18.04"
  description = "Linode-specific image name string"
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

variable "server_instance_type" {
  type        = string
  description = "Cloud provider-specific instance type string to use for rke1 server"
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

variable "insecure_flag" {
  type        = bool
  default     = false
  description = "Flag used to determine if Rancher is using self-signed invalid certs (using a private CA)"
}

variable "k8s_version" {
  type        = string
  default     = "v1.22.9-rancher1-1"
  description = "Version of k8s to use for downstream cluster (RKE1 version string)"
}
