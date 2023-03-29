variable "create_credential" {
  type        = bool
  default     = true
  description = "Boolean used to determine whether or not to create a credential or use a pre-existing one. Useful for automation"
}

variable "cloud_cred_name" {
  type        = string
  default     = ""
  description = "(Optional) Name of cloud credential to use."
}

variable "name_suffix" {
  type        = string
  default     = ""
  description = "(Optional) suffix to append to your cloud credential, node template and node pool names"
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "(Optional) Desired cluster name, if not set then one will be generated"
}

variable "cluster_labels" {
  type        = map(any)
  default     = {}
  description = "(Optional) Labels to add to each provisioned cluster"
}

variable "roles_per_pool" {
  type = list(object({
    quantity      = number
    etcd          = optional(bool)
    control-plane = optional(bool)
    worker        = optional(bool)
  }))
  default = [{
    quantity      = 1
    control-plane = true
    etcd          = true
    worker        = true
  }]
  description = <<EOF
  A list of maps where each element contains keys that define the roles and quantity for a given node pool.
  Example: [
    {
      quantity = 3
      etcd = true
      control-plane = true
      worker = true
    }
  ]
  EOF
  validation {
    condition     = contains([1, 3, 5], sum([for i, pool in var.roles_per_pool : pool.quantity if try(pool.etcd == true, false)]))
    error_message = "The number of etcd nodes per cluster must be one of [1, 3, 5]."
  }
  validation {
    condition     = sum([for i, pool in var.roles_per_pool : pool.quantity if try(pool.control-plane == true, false)]) >= 1
    error_message = "The number of control-plane nodes per cluster must be >= 1."
  }
  validation {
    condition     = sum([for i, pool in var.roles_per_pool : pool.quantity if try(pool.worker == true, false)]) >= 1
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

variable "agent_env_vars" {
  type        = list(map(string))
  default     = null
  description = "A list of maps representing Rancher agent environment variables: https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster#agent_env_vars"
  validation {
    condition     = var.agent_env_vars == null ? true : length(var.agent_env_vars) == 0 ? true : sum([for var in var.agent_env_vars : 1 if lookup(var, "name", "false") != "false"]) == length(var.agent_env_vars)
    error_message = "Each env var map must contain key-value pairs for the \"name\" and \"value\" keys."
  }
  validation {
    condition     = var.agent_env_vars == null ? true : length(var.agent_env_vars) == 0 ? true : sum([for var in var.agent_env_vars : 1 if lookup(var, "value", "false") != "false"]) == length(var.agent_env_vars)
    error_message = "Each env var map must contain key-value pairs for the \"name\" and \"value\" keys."
  }
}

variable "create_keypair" {
  type = bool
  default = false
  description = "Boolean used to determine whether or not to create a keypair or use a pre-existing one. Useful for easing the process of ssh-ing into clusters"
}

variable "keypair_name" {
  type        = string
  default     = null
  description = "Name of a key pair within the specified AWS region to add to the cluster's nodes. If this is set and var.ssh_key_path is not set then a new tls_private_key resource will be created and used to create a new aws_key_pair. These new resources will then be added to the rancher2_machine_config_v2"
}

variable "ssh_key_path" {
  default     = null
  type        = string
  description = "Path to the private SSH key file to be used for accessing the cluster node(s)"
}

variable "public_key_path" {
  default     = null
  type        = string
  description = "This variable can only be set if var.ssh_key_path is set. Path to the public SSH key file to be used for creating the AWS keypair for accessing the cluster node(s)"
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

variable "k8s_version" {
  type        = string
  default     = "v1.21.10+rke2r2"
  description = "Version of rke2 to use for downstream cluster"
}
