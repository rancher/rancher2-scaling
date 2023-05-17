variable "rancher_token" {
  default     = null
  type        = string
  description = "Rancher2 API token for authentication"
}

variable "rancher_version" {
  default     = "null"
  type        = string
  description = "The Rancher Server's version"
}

variable "kube_config_path" {
  type        = string
  default     = null
  description = "Path to kubeconfig file on local machine"
}
