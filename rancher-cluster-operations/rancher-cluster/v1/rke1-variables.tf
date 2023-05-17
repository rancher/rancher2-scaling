variable "cloud_provider" {
  type        = string
  default     = null
  description = "A case-sensitive string equal to one of the following: [\"aws\", \"azure\", \"openstack\", \"vsphere\", \"custom\"]."
  validation {
    condition     = try(length(var.cloud_provider) > 0 ? contains(["aws", "azure", "openstack", "vsphere"], var.cloud_provider) : true, var.cloud_provider == null)
    error_message = "Please pass in a case-sensitive string equal to one of the following: [\"aws\", \"azure\", \"openstack\", \"vsphere\"]."
  }
}

variable "cloud_config" {
  type        = any
  default     = null
  description = " (Optional/Computed) The desired cloud provider-specific options for RKE services (object with optional attributes for those defined here https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster#cloud_provider)"
}

variable "addons" {
  type        = string
  default     = null
  description = "(Optional) Addons descripton to deploy on RKE cluster (string). Can be a file(). Default: null https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster#addons"
}

variable "addons_include" {
  type        = list(string)
  default     = null
  description = "(Optional) Addons yaml manifests to deploy on RKE cluster (list). Default: null https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster#addons_include"
}

variable "enable_cri_dockerd" {
  type        = bool
  default     = false
  description = "(Optional) Enable/disable using cri-dockerd"
}

variable "kube_api" {
  type        = any
  default     = null
  description = "(Optional/Computed) Kube API options for RKE services (object with optional attributes for those defined here https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster#kube_api)"
}

variable "kubelet" {
  type        = any
  default     = null
  description = " (Optional/Computed) Kubelet options for RKE services (object with optional attributes for those defined here https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster#kubelet)"
}

variable "kube_controller" {
  type        = any
  default     = null
  description = " (Optional/Computed) Kube Controller options for RKE services (object with optional attributes for those defined here https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster#kube_controller)"
}

variable "kubeproxy" {
  type        = any
  default     = null
  description = "(Optional/Computed) Kubeproxy options for RKE services (object with optional attributes for those defined here https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster#kubeproxy)"
}

variable "scheduler" {
  type        = any
  default     = null
  description = "(Optional/Computed) Scheduler options for RKE services (object with optional attributes for those defined here https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster#scheduler)"
}

variable "etcd" {
  type        = any
  default     = null
  description = "(Optional/Computed) Etcd options for RKE services (object with optional attributes for those defined here https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster#etcd)"
}
