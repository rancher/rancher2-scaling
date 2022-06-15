variable "k8s_distribution" {
  type        = string
  default     = null
  description = ""
  validation {
    condition     = contains(["k3s", "rke1", "rke2"], var.k8s_distribution)
    error_message = "Please pass in a string equal to one of the following: [\"k3s\", \"rke1\", \"rke2\"]."
  }
}

variable "k8s_version" {
  type        = string
  default     = "v1.22.9-rancher1-1"
  description = "Version of k8s to use for downstream cluster (RKE1 version string)"
}

variable "name" {
  type        = string
  default     = "load-testing"
  description = "Unique identifier appended to the Rancher url subdomain"
}

# variable "cluster_type" {
#   type        = string
#   description = "(optional) describe your variable"
#   validation {
#     condition = contains(["imported", "provisioned", "hosted"], var.cluster_type)
#     error_message = "Please pass in a string equal to one of the following: [\"imported\", \"provisioned\", \"hosted\"]."
#   }
# }

variable "description" {
  type        = string
  default     = null
  description = "(optional) describe your variable"
}

variable "labels" {
  type        = map(any)
  default     = {}
  description = "Labels to add to each provisioned cluster"
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
