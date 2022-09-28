variable "random_prefix" {
  type        = string
  default     = "rancher"
  description = "Prefix to be used with random name generation"
}

variable "num_tokens" {
  type    = number
  default = 0
}

variable "num_secrets" {
  type    = number
  default = 0
}

variable "rancher_api_url" {
  type        = string
  description = "api url for rancher server"
}

variable "rancher_token_key" {
  type        = string
  description = "rancher server API token"
}

variable "cluster_name" {
  type        = string
  default     = "local"
  description = "Name of rancher2_cluster to operate on. Not used for the creation of clusters"
}

variable "project_name" {
  type        = string
  default     = "Default"
  description = "Name of rancher2_project to operate on. Not used for the creation of projects"
}

variable "namespace_name" {
  type        = string
  default     = "default"
  description = "Name of rancher2_project to operate on. Not used for the creation of namespaces"
}

variable "secret_data" {
  type = map(any)
  default = {
    bulk_secret = "True"
  }
  description = "Map of key-values to store in each Secret"
}

variable "num_aws_credentials" {
  type    = number
  default = 0
}

variable "aws_region" {
  type        = string
  default     = "us-west-1"
  description = "AWS region string"
}

variable "aws_access_key" {
  type        = string
  description = "AWS access key matching aws_secret_key"
  sensitive   = true
}

variable "aws_secret_key" {
  type        = string
  description = "AWS secret key matching aws_access_key"
  sensitive   = true
}

variable "num_linode_credentials" {
  type    = number
  default = 0
}

variable "linode_token" {
  type        = string
  description = "Linode API token with necessary permissions"
  sensitive   = true
}

variable "num_projects" {
  type    = number
  default = 0
}

variable "num_users" {
  type    = number
  default = 0
}

variable "user_password" {
  type        = string
  description = "Password to use for created users"
  sensitive   = true
}

variable "output_stdout" {
  type        = bool
  default     = false
  description = "Boolean flag that controls if the created component lists will be output to stdout. Recommendation is not to output to stdout."
}

variable "output_local_file" {
  type        = bool
  default     = false
  description = "Boolean flag that controls if the created component lists will be output to a local file. Recommendation is to set this to true."
}
