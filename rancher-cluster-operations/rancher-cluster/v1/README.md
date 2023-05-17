# v1

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | 1.23.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [rancher2_cluster.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_addons"></a> [addons](#input\_addons) | (Optional) Addons descripton to deploy on RKE cluster (string). Can be a file(). Default: null https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster#addons | `string` | `null` | no |
| <a name="input_addons_include"></a> [addons\_include](#input\_addons\_include) | (Optional) Addons yaml manifests to deploy on RKE cluster (list). Default: null https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster#addons_include | `list(string)` | `null` | no |
| <a name="input_agent_env_vars"></a> [agent\_env\_vars](#input\_agent\_env\_vars) | List of maps for optional Agent Env Vars for Rancher agent. Just for Rancher v2.5.6 and above | `list(map(string))` | `null` | no |
| <a name="input_annotations"></a> [annotations](#input\_annotations) | Optional annotations for the Cluster | `map(any)` | `null` | no |
| <a name="input_cloud_config"></a> [cloud\_config](#input\_cloud\_config) | (Optional/Computed) The desired cloud provider-specific options for RKE services (object with optional attributes for those defined here https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster#cloud_provider) | `any` | `null` | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | A case-sensitive string equal to one of the following: ["aws", "azure", "openstack", "vsphere", "custom"]. | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | (optional) describe your variable | `string` | `null` | no |
| <a name="input_enable_cri_dockerd"></a> [enable\_cri\_dockerd](#input\_enable\_cri\_dockerd) | (Optional) Enable/disable using cri-dockerd | `bool` | `false` | no |
| <a name="input_etcd"></a> [etcd](#input\_etcd) | (Optional/Computed) Etcd options for RKE services (object with optional attributes for those defined here https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster#etcd) | `any` | `null` | no |
| <a name="input_k8s_distribution"></a> [k8s\_distribution](#input\_k8s\_distribution) | The K8s distribution to use for setting up the cluster. One of k3s, rke1, or rke2. | `string` | `null` | no |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | Version of k8s to use for downstream cluster (RKE1 version string) | `string` | `null` | no |
| <a name="input_kube_api"></a> [kube\_api](#input\_kube\_api) | (Optional/Computed) Kube API options for RKE services (object with optional attributes for those defined here https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster#kube_api) | `any` | `null` | no |
| <a name="input_kube_controller"></a> [kube\_controller](#input\_kube\_controller) | (Optional/Computed) Kube Controller options for RKE services (object with optional attributes for those defined here https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster#kube_controller) | `any` | `null` | no |
| <a name="input_kubelet"></a> [kubelet](#input\_kubelet) | (Optional/Computed) Kubelet options for RKE services (object with optional attributes for those defined here https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster#kubelet) | `any` | `null` | no |
| <a name="input_kubeproxy"></a> [kubeproxy](#input\_kubeproxy) | (Optional/Computed) Kubeproxy options for RKE services (object with optional attributes for those defined here https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster#kubeproxy) | `any` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to add to each provisioned cluster | `map(any)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Unique identifier appended to the Rancher url subdomain | `string` | `"load-testing"` | no |
| <a name="input_network_config"></a> [network\_config](#input\_network\_config) | (Optional/Computed) Network config options for any valid cluster config (object with optional attributes for any network-related options defined here https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster) | `any` | `null` | no |
| <a name="input_scheduler"></a> [scheduler](#input\_scheduler) | (Optional/Computed) Scheduler options for RKE services (object with optional attributes for those defined here https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster#scheduler) | `any` | `null` | no |
| <a name="input_sensitive_output"></a> [sensitive\_output](#input\_sensitive\_output) | Bool that determines if certain outputs should be marked as sensitive and be masked. Default: false | `bool` | `false` | no |
| <a name="input_upgrade_strategy"></a> [upgrade\_strategy](#input\_upgrade\_strategy) | (Optional/Computed) Upgrade strategy options for the proper cluster type (object with optional attributes for those defined here https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster) | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_registration_token"></a> [cluster\_registration\_token](#output\_cluster\_registration\_token) | n/a |
| <a name="output_default_project_id"></a> [default\_project\_id](#output\_default\_project\_id) | n/a |
| <a name="output_driver"></a> [driver](#output\_driver) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_insecure_registration_command"></a> [insecure\_registration\_command](#output\_insecure\_registration\_command) | n/a |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_registration_command"></a> [registration\_command](#output\_registration\_command) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
