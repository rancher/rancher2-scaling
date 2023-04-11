# linode

Currently must apply multiple times for rke2 clusters to provision

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | 2.4.0 |
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | 1.25.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloud_credential"></a> [cloud\_credential](#module\_cloud\_credential) | ../../rancher-cloud-credential | n/a |
| <a name="module_cluster1_bulk_components"></a> [cluster1\_bulk\_components](#module\_cluster1\_bulk\_components) | ../../bulk-components | n/a |
| <a name="module_node_template"></a> [node\_template](#module\_node\_template) | ../../rancher-node-template | n/a |
| <a name="module_rke1"></a> [rke1](#module\_rke1) | ../../rancher-cluster/v1 | n/a |

## Resources

| Name | Type |
|------|------|
| [local_file.k3s](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.rke1_kube_config](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.rke2](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [rancher2_cluster_sync.k3s](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster_sync) | resource |
| [rancher2_cluster_sync.rke1](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster_sync) | resource |
| [rancher2_cluster_sync.rke2](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster_sync) | resource |
| [rancher2_cluster_v2.k3s](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster_v2) | resource |
| [rancher2_cluster_v2.rke2](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster_v2) | resource |
| [rancher2_machine_config_v2.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/machine_config_v2) | resource |
| [rancher2_node_pool.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/node_pool) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_env_vars"></a> [agent\_env\_vars](#input\_agent\_env\_vars) | A list of maps representing Rancher agent environment variables: https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster#agent_env_vars | `list(map(string))` | `null` | no |
| <a name="input_authorized_users"></a> [authorized\_users](#input\_authorized\_users) | (Optional) Linode user accounts (seperated by commas) whose Linode SSH keys will be permitted root access to the created node. | `string` | `null` | no |
| <a name="input_auto_replace_timeout"></a> [auto\_replace\_timeout](#input\_auto\_replace\_timeout) | Time to wait after Cluster becomes Active before deleting nodes that are unreachable | `number` | `null` | no |
| <a name="input_cloud_cred_name"></a> [cloud\_cred\_name](#input\_cloud\_cred\_name) | (Optional) Name to use for the cloud credential. | `string` | `""` | no |
| <a name="input_cluster_labels"></a> [cluster\_labels](#input\_cluster\_labels) | (Optional) Labels to add to each provisioned cluster | `map(any)` | `{}` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | (Optional) Desired cluster name, if not set then one will be generated | `string` | `""` | no |
| <a name="input_create_node_reqs"></a> [create\_node\_reqs](#input\_create\_node\_reqs) | Flag defining if a cloud credential & node template should be created on tf apply. Useful for scripting purposes | `bool` | `true` | no |
| <a name="input_enable_cri_dockerd"></a> [enable\_cri\_dockerd](#input\_enable\_cri\_dockerd) | (Optional) Enable/disable using cri-dockerd | `bool` | `false` | no |
| <a name="input_image"></a> [image](#input\_image) | Linode-specific image name string | `string` | `"linode/ubuntu18.04"` | no |
| <a name="input_insecure_flag"></a> [insecure\_flag](#input\_insecure\_flag) | Flag used to determine if Rancher is using self-signed invalid certs (using a private CA) | `bool` | `false` | no |
| <a name="input_install_docker_version"></a> [install\_docker\_version](#input\_install\_docker\_version) | The version of docker to install. Available docker versions can be found at: https://github.com/rancher/install-docker | `string` | `"20.10"` | no |
| <a name="input_k3s_version"></a> [k3s\_version](#input\_k3s\_version) | n/a | `any` | n/a | yes |
| <a name="input_kube_api_debugging"></a> [kube\_api\_debugging](#input\_kube\_api\_debugging) | A flag defining if more verbose logging should be enabled for the kube\_api service | `bool` | `false` | no |
| <a name="input_linode_token"></a> [linode\_token](#input\_linode\_token) | n/a | `string` | `null` | no |
| <a name="input_name_suffix"></a> [name\_suffix](#input\_name\_suffix) | (Optional) suffix to append to your cloud credential, node template and node pool names. This must be unique per-workspace in order to not conflict with any resources | `string` | `""` | no |
| <a name="input_node_template_engine_fields"></a> [node\_template\_engine\_fields](#input\_node\_template\_engine\_fields) | A map of one-to-one keys with the various engine settings available on the `rancher2_node_template` resource: https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/node_template#engine_storage_driver | <pre>object({<br>    engine_env               = optional(map(string), null)<br>    engine_insecure_registry = optional(list(string), null)<br>    engine_install_url       = optional(string, null)<br>    engine_label             = optional(map(string), null)<br>    engine_opt               = optional(map(string), null)<br>    engine_registry_mirror   = optional(list(string), null)<br>    engine_storage_driver    = optional(string, null)<br>  })</pre> | `null` | no |
| <a name="input_node_template_name"></a> [node\_template\_name](#input\_node\_template\_name) | (Optional) Name to use for the node template. | `string` | `""` | no |
| <a name="input_rancher_api_url"></a> [rancher\_api\_url](#input\_rancher\_api\_url) | api url for rancher server | `string` | n/a | yes |
| <a name="input_rancher_token_key"></a> [rancher\_token\_key](#input\_rancher\_token\_key) | rancher server API token | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Cloud provider-specific region string. Defaults to an AWS-specific region | `string` | `"us-west-1"` | no |
| <a name="input_rke1_version"></a> [rke1\_version](#input\_rke1\_version) | n/a | `any` | n/a | yes |
| <a name="input_rke2_version"></a> [rke2\_version](#input\_rke2\_version) | n/a | `any` | n/a | yes |
| <a name="input_server_instance_type"></a> [server\_instance\_type](#input\_server\_instance\_type) | Cloud provider-specific instance type string to use for rke1 server | `string` | n/a | yes |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | Size of the storage volume to use in GB | `string` | `"32"` | no |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | Type of storage volume to use | `string` | `"gp2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_names"></a> [cluster\_names](#output\_cluster\_names) | n/a |
| <a name="output_create_node_reqs"></a> [create\_node\_reqs](#output\_create\_node\_reqs) | n/a |
| <a name="output_cred_name"></a> [cred\_name](#output\_cred\_name) | n/a |
| <a name="output_nt_names"></a> [nt\_names](#output\_nt\_names) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
