variable "cluster_name" {
}

variable "server_node_count" {
}

variable "install_docker_version" {
  type        = string
  default     = "20.10"
  description = "Version of Docker to install"
}

variable "install_k8s_version" {
  type        = string
  description = "Version of K8s to install"
}

variable "s3_instance_profile" {
  default     = ""
  type        = string
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

variable "ssh_key_path" {
  default     = null
  type        = string
  description = "Path to the ssh_key file to be used for connecting to the nodes"
}
