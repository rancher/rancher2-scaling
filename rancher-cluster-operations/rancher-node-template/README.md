# node-template

This component module can be used to create or retrieve a `rancher2_node_template` resource.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_rancher2"></a> [rancher2](#requirement\_rancher2) | >= 1.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | 1.23.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [rancher2_node_template.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/node_template) | resource |
| [rancher2_node_template.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/data-sources/node_template) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_annotations"></a> [annotations](#input\_annotations) | Annotations for Node Template | `map(string)` | `null` | no |
| <a name="input_cloud_cred_id"></a> [cloud\_cred\_id](#input\_cloud\_cred\_id) | n/a | `string` | n/a | yes |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | n/a | `string` | n/a | yes |
| <a name="input_create_new"></a> [create\_new](#input\_create\_new) | Flag defining if a new node template should be created on each tf apply. Useful for scripting purposes | `bool` | `true` | no |
| <a name="input_engine_fields"></a> [engine\_fields](#input\_engine\_fields) | A map of one-to-one keys with the various engine settings available on the `rancher2_node_template` resource: https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/node_template#engine_storage_driver | <pre>object({<br>    engine_env               = optional(map(string), null)<br>    engine_insecure_registry = optional(list(string), null)<br>    engine_install_url       = optional(string, null)<br>    engine_label             = optional(map(string), null)<br>    engine_opt               = optional(map(string), null)<br>    engine_registry_mirror   = optional(list(string), null)<br>    engine_storage_driver    = optional(string, null)<br>  })</pre> | `{}` | no |
| <a name="input_install_docker_version"></a> [install\_docker\_version](#input\_install\_docker\_version) | The version of docker to install. Available docker versions can be found at: https://github.com/rancher/install-docker | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels for Node Template | `map(string)` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_node_config"></a> [node\_config](#input\_node\_config) | (Optional/Computed) Node configuration object (object with optional attributes for those defined here https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster#cloud_provider) | `any` | n/a | yes |
| <a name="input_node_taints"></a> [node\_taints](#input\_node\_taints) | Node taints. For Rancher v2.3.3 or above | <pre>list(object({<br>    key        = optional(string, null)<br>    value      = optional(string, null)<br>    effect     = optional(string, null)<br>    time_added = optional(string, null)<br>  }))</pre> | `[]` | no |
| <a name="input_use_internal_ip_address"></a> [use\_internal\_ip\_address](#input\_use\_internal\_ip\_address) | Engine storage driver for the node template | `bool` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_node_template"></a> [node\_template](#output\_node\_template) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
