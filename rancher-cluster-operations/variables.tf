variable "rancher_url" {
  default     = null
  type        = string
  description = "The Rancher Server's URL"
}

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

variable "cluster_context" {
  default     = null
  type        = string
  description = "Context of the cluster to operate on."
}

variable "kube_config_path" {
  default     = null
  type        = string
  description = "Path on the local filesystem to the kube_config file for the cluster."
}

variable "enable_controllers_metrics" {
  default     = false
  type        = bool
  description = "Boolean that defines whether or not to setup the K8s resources required to enable Rancher's Controllers metrics"
}