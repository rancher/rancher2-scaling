variable "cluster_name" {
  type        = string
  default     = "local"
  description = "Name of the cluster"
}

variable "user" {
  type        = string
  default     = "ubuntu"
  description = "Name of the user to SSH as"
}

variable "cloud_provider_name" {
  type        = string
  default     = null
  description = "A string designating the desired cloud provider's name. https://registry.terraform.io/providers/rancher/rke/latest/docs/resources/cluster#name"
}

variable "cloud_provider_config" {
  type        = map(any)
  default     = null
  description = "A map containing the values for a known cloud provider's configuration. https://registry.terraform.io/providers/rancher/rke/latest/docs/resources/cluster#cloud_provider"
}

variable "custom_cloud_provider_config" {
  type        = string
  default     = null
  description = "A multiline string for configuring a custom cloud provider. https://registry.terraform.io/providers/rancher/rke/latest/docs/resources/cluster#custom_cloud_provider"
}

variable "hostname_override_prefix" {
  type        = string
  default     = ""
  description = "String to prepend to the hostname_override field for each node. (Ignored for AWS cloud provider)"
}

variable "install_k8s_version" {
  type        = string
  default     = ""
  description = "Version of K8s to install"
}

variable "s3_instance_profile" {
  type        = string
  default     = ""
  description = "Optional: String that defines the name of the IAM Instance Profile that grants S3 access to the EC2 instances. Required if 'byo_certs_bucket_path' is set"
}

variable "nodes_ids" {
  type        = list(string)
  description = "Node IDs of the desired nodes for the RKE HA setup"
}

variable "nodes_public_ips" {
  type        = list(string)
  description = "Public IP addresses of the desired nodes for the RKE HA setup"
}

variable "nodes_private_ips" {
  type        = list(string)
  description = "Private IP addresses of the desired nodes for the RKE HA setup"
}

variable "dedicated_monitoring_node" {
  type        = bool
  default     = false
  description = "Boolean that determines whether or not one of the given nodes will be taintend and labelled as a dedicated monitoring node."
}

variable "ssh_key_path" {
  type        = string
  default     = null
  description = "Path to the ssh_key file to be used for connecting to the nodes"
}

variable "secrets_encryption" {
  type        = bool
  default     = false
  description = "(Optional) Boolean that determines if secrets-encryption should be enabled for rke1"
}

variable "enable_cri_dockerd" {
  type        = bool
  default     = true
  description = "(Optional) Boolean that determines if CRI dockerd is enabled for the kubelet (required for k8s >= v1.24.x)"
}
