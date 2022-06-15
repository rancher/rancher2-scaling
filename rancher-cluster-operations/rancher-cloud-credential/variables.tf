variable "create_new" {
  type        = bool
  default     = true
  description = "Flag defining if a new cloud credential should be created on each tf apply. Useful for scripting purposes"
}

variable "name" {
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

variable "credential_config" {
  type      = any
  nullable  = false
  sensitive = true
}
