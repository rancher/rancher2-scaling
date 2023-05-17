variable "create_new" {
  type        = bool
  default     = true
  description = "Flag defining if a new rancher2_cloud_credential should be created on each tf apply. Useful for scripting purposes"
}

variable "name" {
  type        = string
  description = "Display name of the rancher2_cloud_credential"
  nullable    = false
}

variable "cloud_provider" {
  type        = string
  description = "A string defining which cloud provider to dynamically create a rancher2_cloud_credential for"
  nullable    = false
  validation {
    condition     = contains(["aws", "linode"], var.cloud_provider)
    error_message = "Please pass in a case-sensitive string equal to one of the following: [\"aws\", \"linode\"]."
  }
}

variable "credential_config" {
  type = object({
    access_key = optional(string)
    secret_key = optional(string)
    region     = optional(string)
    token      = optional(string)
  })
  description = "An object containing your cloud provider's specific rancher2_cloud_credential config fields in order to dynamically map to them"
  nullable    = false
  sensitive   = true
}
