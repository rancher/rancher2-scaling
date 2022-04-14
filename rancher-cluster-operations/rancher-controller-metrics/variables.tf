variable "rancher_token" {
  default     = null
  type        = string
  description = "Rancher2 API token for authentication"
}

variable "rancher_token_id" {
  default     = null
  type        = string
  description = "Rancher2 API token's ID for authentication"
}

variable "rancher_version" {
  default     = "null"
  type        = string
  description = "The Rancher Server's version"
}