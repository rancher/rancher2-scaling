variable "k8s_distribution" {
  type        = string
  default     = null
  description = "The K8s distribution to use for setting up the cluster. One of k3s, rke1, or rke2."
  validation {
    condition     = contains(["k3s", "rke1", "rke2"], var.k8s_distribution)
    error_message = "Please pass in a string equal to one of the following: [\"k3s\", \"rke1\", \"rke2\"]."
  }
}

variable "k8s_version" {
  type        = string
  default     = null
  description = "Version of k8s to use for downstream cluster (RKE1 version string)"
}

variable "name" {
  type        = string
  default     = "load-testing"
  description = "Unique identifier appended to the Rancher url subdomain"
}

variable "description" {
  type        = string
  default     = null
  description = "(optional) describe your variable"
}

variable "annotations" {
  type        = map(any)
  default     = null
  description = "Optional annotations for the Cluster"
}

variable "labels" {
  type        = map(any)
  default     = {}
  description = "Labels to add to each provisioned cluster"
}

variable "agent_env_vars" {
  type        = list(map(string))
  default     = null
  description = "List of maps for optional Agent Env Vars for Rancher agent. Just for Rancher v2.5.6 and above"
}

variable "sensitive_output" {
  type        = bool
  default     = false
  description = "Bool that determines if certain outputs should be marked as sensitive and be masked. Default: false"
}

variable "upgrade_strategy" {
  type        = any
  default     = null
  description = "(Optional/Computed) Upgrade strategy options for the proper cluster type (object with optional attributes for those defined here https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster)"
}


variable "network_config" {
  type        = any
  default     = null
  description = "(Optional/Computed) Network config options for any valid cluster config (object with optional attributes for any network-related options defined here https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster)"
}
