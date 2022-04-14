variable "name_prefix" {
  type        = string
  default     = "tf-secret"
  description = "(optional) Name prefix for each secret"
}

variable "secrets_per_workspace" {
  type        = number
  default     = 1
  description = "The # of Secrets to create per terraform workspace"
}

variable "cluster_id" {
  type        = string
  default     = "local"
  description = "ID of the cluster where the Secrets should be created"
}


variable "data" {
  type = map(any)
  default = {
    deleteme = "True"
  }
  description = "Map of data to include in each secret"
}
