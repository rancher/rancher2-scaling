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

variable "client_certificate" {
  default     = null
  type        = string
  description = "K8s cluster client certificate"
}

variable "client_key" {
  default     = null
  type        = string
  description = "K8s cluster client key"
}

variable "cluster_ca_certificate" {
  default     = null
  type        = string
  description = "K8s cluster CA certificate"
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
  type        = string
  default     = "https://releases.rancher.com/server-charts/latest"
  description = "The repo URL to use for Rancher Server charts"
}

variable "helm_rancher_chart_values_path" {
  type        = string
  default     = null
  description = "Local path to the templated values.yaml to be used for the Rancher Server Helm install"

}

variable "letsencrypt_email" {
  type        = string
  default     = "none@none.com"
  description = "LetsEncrypt email address to use"
}

variable "rancher_image" {
  type    = string
  default = "rancher/rancher"
}

variable "rancher_image_tag" {
  type        = string
  default     = "release/v2.6"
  description = "Rancher image tag to install, this can differ from rancher_version which is the chart being used to install Rancher"
}

variable "rancher_node_count" {
  type    = number
  default = 1
}

variable "subdomain" {
  default     = null
  type        = string
  description = "subdomain to host rancher on"
}

variable "domain" {
  type    = string
  default = null
}

variable "rancher_password" {
  type        = string
  default     = ""
  description = "Password to set for admin user during bootstrap of Rancher Server, if not set random password will be generated"
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

variable "certmanager_version" {
  type        = string
  default     = "1.5.3"
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