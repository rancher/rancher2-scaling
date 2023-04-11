variable "rancher_api_url" {
  type        = string
  nullable    = false
  description = "API url for Rancher server"
}

variable "rancher_token" {
  type     = string
  nullable = true
  default  = null
}

variable "rancher_version" {
  type        = string
  default     = "2.5.14"
  description = "The version of Rancher to install (must be a 2.5.x version)"
}

variable "kube_config_path" {
  type        = string
  default     = null
  description = "Path to kubeconfig file on local machine"
}

variable "kube_config_context" {
  type        = string
  default     = null
  description = "Context to use for kubernetes operations"
}

variable "letsencrypt_email" {
  type        = string
  default     = null
  description = "LetsEncrypt email address to use"
}

variable "rancher_node_count" {
  type    = number
  default = null
}

variable "rancher_password" {
  type        = string
  default     = ""
  description = "Password to set for admin user during bootstrap of Rancher Server, if not set random password will be generated"
}
