variable "name_suffix" {
  type        = string
  default     = ""
  description = "(Optional) suffix to append to your cloud credential, node template and node pool names. This must be unique per-workspace in order to not conflict with any resources"
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

variable "cloud_cred_name" {
  type        = string
  default     = ""
  description = "(Optional) Name to use for the cloud credential."
}

variable "node_template_name" {
  type        = string
  default     = ""
  description = "(Optional) Name to use for the node template."
}

variable "create_node_reqs" {
  type        = bool
  default     = true
  description = "Flag defining if a cloud credential & node template should be created on tf apply. Useful for scripting purposes"
}

variable "region" {
  type        = string
  default     = "us-west-1"
  description = "Cloud provider-specific region string. Defaults to an AWS-specific region"
}

variable "linode_token" {
  type      = string
  default   = null
  sensitive = true
}

variable "authorized_users" {
  type        = string
  default     = null
  description = "(Optional) Linode user accounts (seperated by commas) whose Linode SSH keys will be permitted root access to the created node."
}

variable "image" {
  type        = string
  default     = "linode/ubuntu18.04"
  description = "Linode-specific image name string"
}

variable "install_docker_version" {
  type        = string
  default     = "20.10"
  description = "The version of docker to install. Available docker versions can be found at: https://github.com/rancher/install-docker"
}

variable "server_instance_type" {
  type        = string
  description = "Cloud provider-specific instance type string to use for rke1 server"
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
  default     = "v1.22.9-rancher1-1"
  description = "Version of k8s to use for downstream cluster (RKE1 version string)"
}
