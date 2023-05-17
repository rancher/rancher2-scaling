variable "create_new" {
  type        = bool
  default     = true
  nullable    = false
  description = "Flag defining if a new node template should be created on each tf apply. Useful for scripting purposes"
}

variable "name" {
  type     = string
  nullable = false
}

variable "cloud_cred_id" {
  type     = string
  nullable = false
}

variable "cloud_provider" {
  type     = string
  nullable = false
  validation {
    condition     = contains(["aws", "linode"], var.cloud_provider)
    error_message = "Please pass in a case-sensitive string equal to one of the following: [\"aws\", \"linode\"]."
  }
}

variable "node_config" {
  type        = any
  nullable    = false
  sensitive   = true
  description = "(Optional/Computed) Node configuration object (object with optional attributes for those defined here https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster#cloud_provider)"
}

variable "install_docker_version" {
  type = string
  # default     = "20.10"
  default     = null
  description = "The version of docker to install. Available docker versions can be found at: https://github.com/rancher/install-docker"
}

variable "engine_fields" {
  type = object({
    engine_env               = optional(map(string), null)
    engine_insecure_registry = optional(list(string), null)
    engine_install_url       = optional(string, null)
    engine_label             = optional(map(string), null)
    engine_opt               = optional(map(string), null)
    engine_registry_mirror   = optional(list(string), null)
    engine_storage_driver    = optional(string, null)
  })
  default     = {}
  description = "A map of one-to-one keys with the various engine settings available on the `rancher2_node_template` resource: https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/node_template#engine_storage_driver"
}

variable "node_taints" {
  type = list(object({
    key        = optional(string, null)
    value      = optional(string, null)
    effect     = optional(string, null)
    time_added = optional(string, null)
  }))
  default     = []
  description = "Node taints. For Rancher v2.3.3 or above"
}

variable "use_internal_ip_address" {
  type        = bool
  default     = null
  description = "Engine storage driver for the node template"
}

variable "annotations" {
  type        = map(string)
  default     = null
  description = "Annotations for Node Template"
}

variable "labels" {
  type        = map(string)
  default     = null
  description = "Labels for Node Template"
}
