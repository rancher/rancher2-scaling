variable "kube_config_path" {
  default     = null
  type        = string
  description = "Path to kubeconfig file on local machine"
}

variable "cluster_host_url" {
  default     = null
  type        = string
  description = "K8s cluster api server url"
}

variable "install_certmanager" {
  default     = true
  type        = bool
  description = "Boolean that defines whether or not to install Cert-Manager"
}

variable "install_rancher" {
  default     = true
  type        = bool
  description = "Boolean that defines whether or not to install Rancher"
}

variable "helm_rancher_repo" {
  default     = "https://releases.rancher.com/server-charts/latest"
  type        = string
  description = "The repo URL to use for Rancher Server charts"
}

variable "helm_rancher_chart_values_path" {
  default     = null
  type        = string
  description = "Local path to the templated values.yaml to be used for the Rancher Server Helm install"
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

variable "rancher_additional_values" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = "A list of objects representing override values for the Rancher helm chart, see https://helm.sh/docs/chart_best_practices/values/#consider-how-users-will-use-your-values"
  validation {
    condition     = length(var.rancher_additional_values) == 0 ? true : sum([for var in var.rancher_additional_values : 1 if length(lookup(var, "name", "")) > 0 ]) == length(var.rancher_additional_values)
    error_message = "Each env var object must contain key-value pairs for the \"name\" and \"value\" keys."
  }
  validation {
    condition     = length(var.rancher_additional_values) == 0 ? true : sum([for var in var.rancher_additional_values : 1 if length(lookup(var, "value", "")) > 0 ]) == length(var.rancher_additional_values)
    error_message = "Each env var object must contain key-value pairs for the \"name\" and \"value\" keys."
  }
}

variable "ingress_class" {
  type        = string
  default     = "nginx"
  description = "Which Rancher-supported ingress to use"
  validation {
    condition     = contains(["nginx", "traefik"], var.ingress_class)
    error_message = "The selected ingress class must be one of: [\"nginx\", \"traefik\"]."
  }
}

variable "letsencrypt_email" {
  default     = null
  type        = string
  description = "LetsEncrypt email address to use"
}

variable "rancher_image" {
  default = "rancher/rancher"
  type    = string
}

variable "rancher_image_tag" {
  default     = null
  type        = string
  description = "Rancher image tag to install, this can differ from rancher_version which is the chart being used to install Rancher"
}

variable "rancher_node_count" {
  default = 1
  type    = number
}

variable "subdomain" {
  default     = null
  type        = string
  description = "subdomain to host rancher on"
}

variable "domain" {
  default = null
  type    = string
}

variable "rancher_password" {
  default     = ""
  type        = string
  description = "Password to set for admin user during bootstrap of Rancher Server, if not set random password will be generated"
}

variable "use_new_bootstrap" {
  default     = true
  type        = bool
  description = "Boolean that defines whether or not utilize the new bootstrap password process used in 2.6.x"
}

variable "rancher_version" {
  type        = string
  description = "Version of Rancher to install - Do not include the v prefix."
}

variable "certmanager_version" {
  default     = "1.8.1"
  type        = string
  description = "Version of cert-manager to install"
}

variable "byo_certs_bucket_path" {
  default     = ""
  type        = string
  description = "Optional: String that defines the path on the S3 Bucket where your certs are stored. NOTE: assumes certs are stored in a tarball within a folder below the top-level bucket e.g.: my-bucket/certificates/my_certs.tar.gz. Certs should be stored within a single folder, certs nested in sub-folders will not be handled"
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

variable "cattle_prometheus_metrics" {
  default     = true
  type        = bool
  description = "Boolean variable that defines whether or not to enable the CATTLE_PROMETHEUS_METRICS env var for Rancher"
}
