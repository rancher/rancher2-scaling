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

variable "rancher_loglevel" {
  type        = string
  description = "A string specifying the loglevel to set on the rancher pods. One of: info, debug or trace. https://rancher.com/docs/rancher/v2.x/en/troubleshooting/logging/"
  default     = "info"
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
  default     = "1.8.1"
  description = "Version of cert-manager to install"
}

variable "s3_instance_profile" {
  default     = ""
  type        = string
  description = "Optional: String that defines the name of the IAM Instance Profile that grants S3 access to the EC2 instances."
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

variable "enable_audit_log" {
  type        = bool
  default     = false
  description = "(Optional) Boolean that determines if secrets-encryption should be enabled"
}
