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
  description = "AWS-specific region string. Defaults to an AWS-specific region"
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

variable "image" {
  type        = string
  default     = "ubuntu-minimal/images/*/ubuntu-bionic-18.04-*"
  description = "Specific AWS AMI or AMI name filter to use"
}

variable "iam_instance_profile" {
  type    = string
  default = null
}

variable "install_docker_version" {
  type        = string
  default     = "20.10"
  description = "The version of docker to install. Available docker versions can be found at: https://github.com/rancher/install-docker"
}

variable "security_groups" {
  type        = list(any)
  default     = []
  description = "A list of security group names (EC2-Classic) or IDs (default VPC) to associate with"
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

variable "rke1_version" {
  validation {
    condition     = can(regex("v", var.rke1_version))
    error_message = "The version number must be prefixed with 'v'."
  }
}

variable "rke2_version" {
  validation {
    condition     = can(regex("v", var.rke2_version))
    error_message = "The version number must be prefixed with 'v'."
  }
}

variable "k3s_version" {
  validation {
    condition     = can(regex("v", var.k3s_version))
    error_message = "The version number must be prefixed with 'v'."
  }
}

variable "kube_api_debugging" {
  type        = bool
  default     = false
  description = "A flag defining if more verbose logging should be enabled for the kube_api service"
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

variable "enable_cri_dockerd" {
  type        = bool
  default     = false
  description = "(Optional) Enable/disable using cri-dockerd"
}

variable "node_template_engine_fields" {
  type = object({
    engine_env               = optional(map(string), null)
    engine_insecure_registry = optional(list(string), null)
    engine_install_url       = optional(string, null)
    engine_label             = optional(map(string), null)
    engine_opt               = optional(map(string), null)
    engine_registry_mirror   = optional(list(string), null)
    engine_storage_driver    = optional(string, null)
  })
  default     = null
  description = "A map of one-to-one keys with the various engine settings available on the `rancher2_node_template` resource: https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/node_template#engine_storage_driver"
}

variable "auto_replace_timeout" {
  type        = number
  default     = null
  description = "Time to wait after Cluster becomes Active before deleting nodes that are unreachable"
}
