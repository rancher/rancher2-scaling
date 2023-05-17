variable "region" {
  type        = string
  default     = "us-west"
  description = "Cloud provider-specific region string. Defaults to a Linode-compatible region."
}

variable "image" {
  type        = string
  default     = "linode/ubuntu18.04"
  description = "Cloud provider-specific image name string."
}

variable "node_instance_type" {
  type        = string
  default     = "g6-standard-2"
  description = "Cloud provider-specific instance type string to use for the nodes"
}

variable "rancher_api_url" {
  type        = string
  nullable    = false
  description = "api url for rancher server"
}

variable "rancher_token_key" {
  type        = string
  nullable    = false
  description = "rancher server API token"
}

variable "insecure_flag" {
  type        = bool
  default     = false
  description = "Flag used to determine if Rancher is using self-signed invalid certs (using a private CA)"
}

variable "k8s_distribution" {
  type        = string
  default     = "rke1"
  description = "The K8s distribution to use for setting up the cluster. One of k3s, rke1, or rke2."
  nullable    = false
  validation {
    condition     = contains(["k3s", "rke1", "rke2"], var.k8s_distribution)
    error_message = "Please pass in a string equal to one of the following: [\"k3s\", \"rke1\", \"rke2\"]."
  }
}

variable "k8s_version" {
  type        = string
  default     = "v1.20.15-rancher1-4"
  description = "Version of k8s to use for downstream cluster (should match to a valid var.k8s_distribution-specific version). Defaults to a valid RKE1 version"
}

variable "linode_token" {
  type      = string
  default   = null
  sensitive = true
}
