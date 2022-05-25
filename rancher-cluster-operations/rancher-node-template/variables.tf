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
  type        = string
  default     = "20.10"
  description = "The version of docker to install. Available docker versions can be found at: https://github.com/rancher/install-docker"
}
