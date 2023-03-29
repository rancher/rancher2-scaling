variable "cluster_name" {
  type        = string
  default     = ""
  description = "(Optional) Desired cluster name, if not set then one will be generated"
}

variable "roles_per_pool" {
  type        = list(map(string))
  description = <<EOF
  A list of maps where each element contains keys that define the roles and quantity for a given node pool.
  Example: [
    {
      "quantity" = 3
      "etd" = true
      "control-plane" = true
      "worker" = true
    }
  ]
  EOF
  validation {
    condition     = contains([1, 3, 5], sum([for i, pool in var.roles_per_pool : try(tonumber(pool["quantity"]), 1) if try(pool["etcd"] == "true", false)]))
    error_message = "The number of etcd nodes per cluster must be one of [1, 3, 5]."
  }
  validation {
    condition     = sum([for i, pool in var.roles_per_pool : try(tonumber(pool["quantity"]), 1) if try(pool["control-plane"] == "true", false)]) >= 1
    error_message = "The number of control-plane nodes per cluster must be >= 1."
  }
  validation {
    condition     = sum([for i, pool in var.roles_per_pool : try(tonumber(pool["quantity"]), 1) if try(pool["worker"] == "true", false)]) >= 1
    error_message = "The number of worker nodes per cluster must be >= 1."
  }
}

variable "aws_region" {
  type    = string
  default = "us-west-1"
}

variable "aws_access_key" {
  type      = string
  default   = null
  sensitive = true
}

variable "aws_secret_key" {
  type      = string
  default   = null
  sensitive = true
}

variable "iam_instance_profile" {
  type    = string
  default = null
}

variable "security_groups" {
  type        = list(any)
  default     = []
  description = "A list of security group names (EC2-Classic) or IDs (default VPC) to associate with"
}

variable "server_instance_type" {
  type        = string
  description = "Instance type to use for rke2 server"
}

variable "volume_size" {
  type        = string
  default     = "32"
  description = "Size of the storage volume to use in GB"
}

variable "volume_type" {
  type        = string
  default     = "gp2"
  description = "Type of storage volume to use"
}

variable "rancher_api_url" {
  type        = string
  description = "api url for rancher server"
}

variable "rancher_token_key" {
  type        = string
  description = "rancher server API token"
}

variable "insecure_flag" {
  type        = bool
  default     = false
  description = "Flag used to determine if Rancher is using self-signed invalid certs (using a private CA)"
}

variable "k8s_distribution" {
  type        = string
  description = "The K8s distribution to use for setting up Rancher (k3s , rke1, or rke2)"
}

variable "k8s_version" {
  type        = string
  default     = "v1.21.10+rke2r2"
  description = "Version of rke2 to use for downstream cluster"
}

variable "scale_secrets" {
  type = bool
  default = false
}

variable "scale_secretsv2" {
  type = bool
  default = false
}

variable "scale_tokens" {
  type = bool
  default = false
}

variable "scale_aws_cloud_creds" {
  type = bool
  default = false
}

variable "scale_linode_cloud_creds" {
  type = bool
  default = false
}

variable "scale_users" {
  type = bool
  default = false
}

variable "scale_projects" {
  type = bool
  default = false
}
