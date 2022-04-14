variable "create_credential" {
  type        = bool
  default     = true
  description = "Boolean used to determine whether or not to create a credential or use a pre-existing one. Useful for automation"
}

variable "existing_cloud_cred" {
  type        = string
  default     = ""
  description = "(Optional) Name of an existing cloud credential to use. Only use this if create_credential is false."
}

variable "cluster_name" {
  type        = string
  default     = "rke2"
  description = "Unique identifier appended to the Rancher url subdomain"
}

variable "nodes_per_pool" {
  type        = number
  default     = 1
  description = "Number of nodes to create per node pool"
}

variable "roles_per_pool" {
  type        = list(string)
  default     = ["control-plane,worker,etcd"]
  description = "A list of strings where each element defines the roles for a given node pool via a comma-delimited string. ex: [\"control-plane,worker,etcd\", \"control-plane,worker\", \"etcd\", \"etcd\"]"
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
  description = "Instance type to use for rke1 server"
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

variable "cluster_labels" {
  type        = map(any)
  default     = {}
  description = "Labels to add to each provisioned cluster"
}

variable "rke2_version" {
  type        = string
  default     = "v1.21.10+rke2r2"
  description = "Version of rke2 to use for downstream cluster"
}
