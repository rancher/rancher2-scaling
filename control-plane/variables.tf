variable "install_docker_version" {
  type        = string
  default     = "20.10"
  description = "Version of Docker to install"
}

variable "install_k8s_version" {
  type        = string
  default     = ""
  description = "Version of K8s to install"
}

variable "install_rancher" {
  type        = bool
  default     = true
  description = "Boolean that defines whether or not to install Rancher"
}

variable "rancher_version" {
  type        = string
  description = "Version of Rancher to install - Do not include the v prefix."
}

variable "enable_cri_dockerd" {
  type        = bool
  default     = true
  description = "(Optional) Boolean that determines if CRI dockerd is enabled for the kubelet (required for k8s >= v1.24.x)"
}


variable "rancher_loglevel" {
  type        = string
  description = "A string specifying the loglevel to set on the rancher pods. One of: info, debug or trace. https://rancher.com/docs/rancher/v2.x/en/troubleshooting/logging/"
  default     = "info"
}

variable "rancher_env_vars" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = "A list of objects representing Rancher environment variables"
  validation {
    condition     = length(var.rancher_env_vars) == 0 ? true : sum([for var in var.rancher_env_vars : 1 if length(lookup(var, "name", "")) > 0]) == length(var.rancher_env_vars)
    error_message = "Each env var object must contain key-value pairs for the \"name\" and \"value\" keys."
  }
  validation {
    condition     = length(var.rancher_env_vars) == 0 ? true : sum([for var in var.rancher_env_vars : 1 if length(lookup(var, "value", "")) > 0]) == length(var.rancher_env_vars)
    error_message = "Each env var object must contain key-value pairs for the \"name\" and \"value\" keys."
  }
}

variable "rancher_additional_values" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = "A list of objects representing override values for the Rancher helm chart, see https://helm.sh/docs/chart_best_practices/values/#consider-how-users-will-use-your-values"
  validation {
    condition     = length(var.rancher_additional_values) == 0 ? true : sum([for var in var.rancher_additional_values : 1 if length(lookup(var, "name", "")) > 0]) == length(var.rancher_additional_values)
    error_message = "Each env var object must contain key-value pairs for the \"name\" and \"value\" keys."
  }
  validation {
    condition     = length(var.rancher_additional_values) == 0 ? true : sum([for var in var.rancher_additional_values : 1 if length(lookup(var, "value", "")) > 0]) == length(var.rancher_additional_values)
    error_message = "Each env var object must contain key-value pairs for the \"name\" and \"value\" keys."
  }
}

variable "rancher_values_yaml" {
  type        = string
  default     = ""
  description = "Absolute filepath to the desired values.yaml for the Rancher helm chart. Defaults to a yaml template stored in the install_common module"
}

variable "cattle_prometheus_metrics" {
  default     = true
  type        = bool
  description = "Boolean variable that defines whether or not to enable the CATTLE_PROMETHEUS_METRICS env var for Rancher"
}

variable "install_monitoring" {
  type        = bool
  default     = true
  description = "Boolean that defines whether or not to install rancher-monitoring"
}

variable "monitoring_version" {
  type        = string
  description = "Version of Monitoring v2 to install - Do not include the v prefix."
}

variable "monitoring_crd_chart_values_path" {
  type        = string
  default     = null
  description = "Path to custom values.yaml for rancher-monitoring"
}

variable "monitoring_chart_values_path" {
  type        = string
  default     = null
  description = "Path to custom values.yaml for rancher-monitoring"
}

variable "rancher_instance_type" {
  default     = "m5.xlarge"
  type        = string
  description = "instance type used for the rancher servers"
}

variable "install_certmanager" {
  default     = true
  type        = bool
  description = "Boolean that defines whether or not to install Cert-Manager"
}

variable "certmanager_version" {
  type        = string
  default     = "1.4.2"
  description = "Version of cert-manager to install"
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

variable "db_name" {
  default = "rancher"
  type    = string
}

variable "db_engine" {
  default = "mariadb"
  type    = string
}

variable "db_engine_version" {
  default = "10.5"
  type    = string
}

variable "db_instance_class" {
  default = "db.t3.medium"
  type    = string
}

variable "db_port" {
  default = 3306
  type    = number
}

variable "db_allocated_storage" {
  default = 100
  type    = number
}

variable "db_storage_encrypted" {
  default = false
  type    = bool
}

variable "db_storage_type" {
  default = "io1"
  type    = string
}

variable "db_iops" {
  default = 1000
  type    = number
}

variable "db_username" {
  default = "rancher"
  type    = string
}

variable "db_password" {
  default     = "rancher12345"
  type        = string
  description = "Password string for database, must be >= 8 characters. Only printable ASCII characters are allowed, the following are not allowed: '/@\" ' "
}

variable "db_skip_final_snapshot" {
  default = true
  type    = bool
}

variable "db_subnet_group_name" {
  description = "Name of DB subnet group. DB instance will be created in the VPC associated with the DB subnet group. If unspecified, will be created in the default VPC"
  type        = string
  default     = null
}

variable "ssh_keys" {
  type        = list(any)
  default     = []
  description = "SSH keys to inject into Rancher instances"
}

variable "ssh_key_path" {
  default     = null
  type        = string
  description = "Path to the private SSH key file to be used for connecting to the node(s)"
}

variable "rancher_image" {
  type    = string
  default = "rancher/rancher"
}

variable "rancher_image_tag" {
  type        = string
  default     = "master-head"
  description = "Rancher image tag to install, this can differ from rancher_version which is the chart being used to install Rancher"
}

variable "rancher_node_count" {
  type    = number
  default = 1
}

variable "k8s_distribution" {
  type        = string
  description = "The K8s distribution to use for setting up Rancher (k3s , rke1, or rke2)"
}

variable "install_k3s_version" {
  default     = "1.20.10+k3s1"
  type        = string
  description = "Version of K3S to install (github release tag without the 'v')"
}

variable "install_rke2_channel" {
  default     = "stable"
  type        = string
  description = "Release channel to use for fetching RKE2 download URL, defaults to stable"
}
variable "install_rke2_version" {
  default     = ""
  type        = string
  description = "Version of RKE2 to install (defaults to latest version on the specified channel: https://docs.rke2.io/install/install_options/install_options/#configuring-the-linux-installation-script)"
}

variable "rke2_config" {
  type        = string
  default     = ""
  description = "(Optional) A formatted string that will be appended to the final rke2 config yaml"
}

variable "rancher_password" {
  type        = string
  default     = ""
  description = "Password to set for admin user during bootstrap of Rancher Server, if not set random password will be generated"
}

variable "random_prefix" {
  type        = string
  default     = "rancher"
  description = "Prefix to be used with random name generation"
}

variable "server_k3s_exec" {
  default     = ""
  type        = string
  description = "exec args to pass to k3s server"
}

variable "agent_k3s_exec" {
  default     = ""
  type        = string
  description = "exec args to pass to k3s agent"
}

variable "rancher_chart" {
  type        = string
  default     = "stable"
  description = "Helm chart to use for Rancher install"
}

variable "rancher_charts_repo" {
  type        = string
  default     = "https://git.rancher.io/charts"
  description = "The URL for the desired Rancher charts"
}

variable "rancher_charts_branch" {
  type        = string
  default     = "release-v2.6"
  description = "The github branch for the desired Rancher chart version"
}

variable "letsencrypt_email" {
  type        = string
  default     = "none@none.com"
  description = "LetsEncrypt email address to use"
}

variable "aws_region" {
  type    = string
  default = "us-west-2"
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

variable "sensitive_token" {
  type        = bool
  default     = true
  description = "Boolean that determines if the module should treat the generated Rancher Admin API Token as sensitive in the output."
}

variable "enable_secrets_encryption" {
  type        = bool
  default     = false
  description = "(Optional) Boolean that determines if secrets-encryption should be enabled"
}
