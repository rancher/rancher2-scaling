variable "kube_config_path" {
  default     = null
  type        = string
  description = "Path to kubeconfig file on local machine"
}

variable "release_prefix" {

}

variable "num_charts" {
  default = 1
}

variable "local_chart_path" {
  default = null
}

variable "namespace" {

}
