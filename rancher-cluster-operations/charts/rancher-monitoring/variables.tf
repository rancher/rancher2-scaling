variable "rancher_url" {
  default     = null
  type        = string
  description = "The Rancher Server's URL"
}

variable "rancher_token" {
  default     = null
  type        = string
  description = "Rancher2 API token for authentication"
}

variable "use_v2" {
  default     = true
  type        = bool
  description = "Boolean to determine which version of rancher_catalog and rancher_app to use"
}

variable "charts_repo" {
  default     = "https://git.rancher.io/charts"
  type        = string
  description = "Url to repo hosting charts"
}

variable "charts_branch" {
  default     = "release-v2.6"
  type        = string
  description = "The github branch for the desired Rancher chart version"
}

variable "chart_version" {
  default     = null
  type        = string
  description = "Version of rancher-monitoring chart to install"
}

variable "values" {
  default     = null
  type        = string
  description = "Values file content for rancher-monitoring"
}

variable "cluster_id" {
  default     = "local"
  type        = string
  description = "(optional) describe your variable"
}

variable "project_id" {
  type = string
}
