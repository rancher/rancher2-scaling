variable "num_users" {
  type        = number
  default     = 0
  description = "Number of new users to create, not to be used with var.users"
}

variable "user_password" {
  type        = string
  description = "Password to use for created users"
  sensitive   = true
}

variable "create_new_users" {
  type = bool
  default = true
}

variable "users" {
  type = list(object({
    name     = string
    username = optional(string)
  }))
  default     = []
  description = "A list of maps with at least a 'name' or username' field, not to be used with var.num_users"
}

variable "user_name_ref_pattern" {
  type = string
  default = ""
}

variable "user_project_binding" {
  type    = bool
  default = false
}

variable "user_cluster_binding" {
  type    = bool
  default = false
}

variable "user_global_binding" {
  type    = bool
  default = false
}
