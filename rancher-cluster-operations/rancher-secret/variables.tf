variable "use_v2" {
  type        = bool
  nullable    = false
  description = "(required) Flag defining whether to create or retrieve a rancher2_secret_v2 or rancher2_secret"
}

variable "create_new" {
  type        = bool
  nullable    = false
  description = "(required) Flag defining if a new Secret should be created on each tf apply. Useful for scripting purposes"
}

variable "annotations" {
  type        = map(string)
  default     = null
  description = "(optional) A map of annotations to add to the Secret"
}

variable "labels" {
  type        = map(string)
  default     = null
  description = "(optional) A map of labels to add to the Secret"
}
variable "description" {
  type        = string
  default     = null
  description = "(rancher2_secret only) Description for the Secret"
}

variable "name" {
  type        = string
  nullable    = false
  description = "(Required) Name for the Secret"
}

variable "namespace" {
  type        = string
  default     = "default"
  description = "(optional) The namespace or namespace_id to create the Secret in"
}

variable "project_id" {
  type        = string
  default     = null
  description = "(rancher2_secret only) ID of the project where the Secret should be created"
}

variable "cluster_id" {
  type        = string
  default     = "local"
  description = "(rancher2_secret_v2 only) ID of the cluster where the Secret should be created"
}

variable "immutable" {
  type        = string
  default     = false
  description = "(optional) If set to true, any Secret update will remove and recreate the Secret. This is a beta field enabled by k8s ImmutableEphemeralVolumes feature gate"
}

variable "type" {
  type        = string
  default     = "Opaque"
  description = "(optional) The type of the Secret, used to facilitate programmatic handling of Secret data. [More info](https://github.com/kubernetes/api/blob/release-1.20/core/v1/types.go#L5772) about k8s Secret types and expected format"
}

variable "data" {
  type        = map(any)
  description = "(required if create_new = true) Map of data to include in each Secret (values can be file paths). Data values for rancher2_secret will be base64encoded as required, therefore do not pass in encoded data"
}
