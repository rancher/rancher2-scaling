variable "rancher_password" {
  type        = string
  default     = ""
  description = "Password to set for admin user during bootstrap of Rancher Server"
}

variable "rancher_version" {
  type        = string
  default     = "2.3.2"
  description = "Version of Rancher to install"
}

variable "agent_image_id" {
  type        = string
  default     = null
  description = "AMI to use for k3s agent instances"
}

variable "server_image_id" {
  type        = string
  default     = null
  description = "AMI to use for k3s server instances"
}

variable "ssh_keys" {
  type        = list
  default     = []
  description = "SSH keys to inject into Rancher instances"
}

variable "rancher_chart" {
  type        = string
  default     = "rancher-stable/rancher"
  description = "Helm chart to use for Rancher install"
}

variable "name" {
  type        = string
  default     = "rancher-demo"
  description = "Name for deployment"
}

variable "letsencrypt_email" {
  type        = string
  default     = "none@none.com"
  description = "LetsEncrypt email address to use"
}

variable "domain" {
  type    = string
  default = "eng.rancher.space"
}

variable "r53_domain" {
  type        = string
  default     = ""
  description = "DNS domain for Route53 zone (defaults to domain if unset)"
}

variable "server_instance_type" {
  type    = string
  default = "m5.large"
}

variable "agent_instance_type" {
  type    = string
  default = "m5.large"
}

variable "server_node_count" {
  type        = number
  default     = 1
  description = "Number of server nodes to launch"
}

variable "agent_node_count" {
  type        = number
  default     = 0
  description = "Number of agent nodes to launch"
}

variable "db_node_count" {
  type        = number
  default     = 1
  description = "Number of RDS database instances to launch"
}

variable "server_instance_ssh_user" {
  type        = string
  default     = "ubuntu"
  description = "Username for sshing into instances"
}

variable "agent_instance_ssh_user" {
  type        = string
  default     = "ubuntu"
  description = "Username for sshing into instances"
}

variable "certmanager_version" {
  type        = string
  default     = "0.9.1"
  description = "Version of cert-manager to install"
}

variable "vpc_id" {
  type        = string
  default     = null
  description = "The vpc id that Rancher should use"
}

variable "aws_region" {
  type    = string
  default = null
}

variable "aws_profile" {
  type        = string
  default     = null
  description = "Name of the AWS Profile to use for authentication"
}

variable "public_subnets" {
  default     = []
  type        = list
  description = "List of public subnet ids."
}

variable "private_subnets" {
  default     = []
  type        = list
  description = "List of private subnet ids."
}

variable "install_k3s_version" {
  default     = "1.0.0"
  type        = string
  description = "Version of K3S to install"
}

variable "k3s_cluster_secret" {
  default     = null
  type        = string
  description = "Override to set k3s cluster registration secret"
}

variable "extra_server_security_groups" {
  default     = []
  type        = list
  description = "Additional security groups to attach to k3s server instances"
}

variable "extra_agent_security_groups" {
  default     = []
  type        = list
  description = "Additional security groups to attach to k3s agent instances"
}

variable "aws_azs" {
  default     = null
  type        = list
  description = "List of AWS Availability Zones in the VPC"
}

variable "db_instance_type" {
  default = "db.r5.xlarge"
}

variable "db_name" {
  default     = "rancer"
  type        = string
  description = "Name of database to create in RDS"
}

variable "db_user" {
  type        = string
  description = "Username for RDS database"
}

variable "db_pass" {
  type        = string
  description = "Password for RDS user"
}

variable "db_security_group" {
  type = string
}

variable "private_subnets_cidr_blocks" {
  default     = []
  type        = list
  description = "List of cidr_blocks of private subnets"
}

variable "public_subnets_cidr_blocks" {
  default     = []
  type        = list
  description = "List of cidr_blocks of public subnets"
}

variable "skip_final_snapshot" {
  default     = true
  type        = bool
  description = "Boolean that defines whether or not the final snapshot should be created on RDS cluster deletion"
}

variable "install_rancher" {
  default     = false
  type        = bool
  description = "Boolean that defines whether or not to install Rancher"
}

variable "install_nginx_ingress" {
  default     = true
  type        = bool
  description = "Boolean that defines whether or not to install nginx-ingress"
}

variable "install_certmanager" {
  default     = true
  type        = bool
  description = "Boolean that defines whether or not to install Cert-Manager"
}

variable "create_external_nlb" {
  default     = true
  type        = bool
  description = "Boolean that defines whether or not to create an external load balancer"
}

variable "k3s_datastore_cafile" {
  default     = "/srv/rds-combined-ca-bundle.pem"
  type        = string
  description = "Location to download RDS CA Bundle"
}

variable "registration_command" {
  default     = ""
  type        = string
  description = "Registration command to import cluster into Rancher. Should not be used when installing Rancher in this same cluster"
}

variable "k3s_datastore_endpoint" {
  type        = string
  description = "Storage Backend for K3S cluster to use. Valid options are 'sqlite' or 'postgres'"
}

variable "k3s_disable_agent" {
  default     = false
  type        = bool
  description = "Whether to run the k3s agent on the same host as the k3s server"
}

variable "k3s_tls_san" {
  default     = null
  type        = string
  description = "Sets k3s tls-san flag to this value instead of the default load balancer"
}

variable "k3s_deploy_traefik" {
  default     = false
  type        = bool
  description = "Configures whether to deploy traefik ingress or not"
}

variable "rancher2_token_key" {
  default     = null
  type        = string
  description = "Rancher2 API token for authentication"
}

variable "agent_k3s_exec" {
  default     = null
  type        = string
  description = "exec args to pass to k3s agents"
}

variable "server_k3s_exec" {
  default     = null
  type        = string
  description = "exec args to pass to k3s server"
}

variable "use_route53" {
  default     = true
  type        = bool
  description = "Configures whether to use route_53 DNS or not"
}

variable "subdomain" {
  default     = null
  type        = string
  description = "subdomain to host rancher on, instead of using `var.name`"
}

variable "k3s_storage_engine" {
  type = string
}

variable "db_port" {
  type = number
}

variable "user" {
  type = string
}

variable "rancher_image" {
  type    = string
  default = "rancher/rancher"
}

variable "rancher_image_tag" {
  type    = string
  default = "master-head"
}

variable "self_signed" {
  type    = bool
  default = false
  description = "whether host is using self signed certs"
}
