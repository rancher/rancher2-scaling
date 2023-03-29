variable "rancher_password" {
  type        = string
  default     = ""
  description = "Password to set for admin user after bootstrap of Rancher Server"
}

variable "use_new_bootstrap" {
  type        = bool
  default     = true
  description = "Boolean that defines whether or not utilize the new bootstrap password process used in 2.6.x"
}

variable "rancher_version" {
  type        = string
  description = "Version of Rancher to install - Do not include the v prefix."
}

variable "monitoring_version" {
  type        = string
  description = "Version of Monitoring v2 to install - Do not include the v prefix."
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
  type        = list(any)
  default     = []
  description = "SSH keys to inject into Rancher instances"
}

variable "rancher_chart" {
  type        = string
  default     = "rancher-stable/rancher"
  description = "Helm chart to use for Rancher install"
}

variable "rancher_chart_tag" {
  type        = string
  default     = "release-v2.5"
  description = "The github tag for the desired Rancher chart version"
}

variable "rancher_env_vars" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = "A list of objects representing Rancher environment variables"
  validation {
    condition     = length(var.rancher_env_vars) == 0 ? true : sum([for var in var.rancher_env_vars : 1 if length(lookup(var, "name", "")) > 0 ]) == length(var.rancher_env_vars)
    error_message = "Each env var object must contain key-value pairs for the \"name\" and \"value\" keys."
  }
  validation {
    condition     = length(var.rancher_env_vars) == 0 ? true : sum([for var in var.rancher_env_vars : 1 if length(lookup(var, "value", "")) > 0 ]) == length(var.rancher_env_vars)
    error_message = "Each env var object must contain key-value pairs for the \"name\" and \"value\" keys."
  }
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
  default = ""
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
  default     = "1.5.2"
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
  type        = list(any)
  description = "List of public subnet ids."
}

variable "private_subnets" {
  default     = []
  type        = list(any)
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
  type        = list(any)
  description = "Additional security groups to attach to k3s server instances"
}

variable "extra_agent_security_groups" {
  default     = []
  type        = list(any)
  description = "Additional security groups to attach to k3s agent instances"
}

variable "aws_azs" {
  default     = null
  type        = list(any)
  description = "List of AWS Availability Zones in the VPC"
}

variable "db_instance_type" {
  default = "db.r5.xlarge"
}

variable "db_engine" {
  type        = string
  default     = "sqlite"
  description = "Engine used to create the database in RDS"
}

variable "db_name" {
  default     = "rancher"
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
  type        = list(any)
  description = "List of cidr_blocks of private subnets"
}

variable "public_subnets_cidr_blocks" {
  default     = []
  type        = list(any)
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

variable "ingress_nginx_version" {
  default     = "v4.3.0"
  type        = string
  description = "Version string of ingress-nginx K8s chart to deploy"
}

variable "install_certmanager" {
  default     = true
  type        = bool
  description = "Boolean that defines whether or not to install Cert-Manager"
}

variable "byo_certs_bucket_path" {
  default     = ""
  type        = string
  description = "Optional: String that defines the path on the S3 Bucket where your certs are stored. NOTE: assumes certs are stored in a tarball within a folder below the top-level bucket e.g.: my-bucket/certificates/my_certs.tar.gz. Certs should be stored within a single folder, certs nested in sub-folders will not be handled"
}

variable "s3_instance_profile" {
  default     = ""
  type        = string
  description = "Optional: String that defines the name of the IAM Instance Profile that grants S3 access to the EC2 instances. Required if 'byo_certs_bucket_path' is set"
}

variable "s3_bucket_region" {
  default     = ""
  type        = string
  description = "Optional: String that defines the AWS region of the S3 Bucket that stores the desired certs. Required if 'byo_certs_bucket_path' is set. Defaults to the aws_region if not set"
}

variable "private_ca_file" {
  default     = ""
  type        = string
  description = "Optional: String that defines the name of the private CA .pem file in the specified S3 bucket's cert tarball"
}

variable "tls_cert_file" {
  default     = ""
  type        = string
  description = "Optional: String that defines the name of the TLS Certificate file in the specified S3 bucket's cert tarball. Required if 'byo_certs_bucket_path' is set"
}

variable "tls_key_file" {
  default     = ""
  type        = string
  description = "Optional: String that defines the name of the TLS Key file in the specified S3 bucket's cert tarball. Required if 'byo_certs_bucket_path' is set"
}

variable "create_agent_nlb" {
  default     = true
  type        = bool
  description = "Boolean that defines whether or not to create an external load balancer"
}

variable "create_internal_nlb" {
  default     = false
  type        = bool
  description = "Boolean that defines whether or not to create an internal load balancer which the k3s.yaml inaccessible outside of the cluster"
}

variable "create_public_nlb" {
  default     = true
  type        = bool
  description = "Boolean that defines whether or not to create an external public load balancer"
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

variable "cattle_prometheus_metrics" {
  default     = true
  type        = bool
  description = "Boolean variable that defines whether or not to enable the CATTLE_PROMETHEUS_METRICS env var for Rancher"
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
