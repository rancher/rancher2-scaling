# rancher-secret

This component module can be used to create or retrieve `rancher2_secret` or `rancher2_secret_v2` resources.

Caveat: Data cannot be larger than 4MB, see the following https://support.hashicorp.com/hc/en-us/articles/4803097239955-gRPC-message-larger-than-max-error

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_rancher2"></a> [rancher2](#requirement\_rancher2) | >= 1.13.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | 1.23.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [rancher2_secret.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/secret) | resource |
| [rancher2_secret_v2.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/secret_v2) | resource |
| [rancher2_secret.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/data-sources/secret) | data source |
| [rancher2_secret_v2.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/data-sources/secret_v2) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_annotations"></a> [annotations](#input\_annotations) | (optional) A map of annotations to add to the Secret | `map(string)` | `null` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | (rancher2\_secret\_v2 only) ID of the cluster where the Secret should be created | `string` | `"local"` | no |
| <a name="input_create_new"></a> [create\_new](#input\_create\_new) | (required) Flag defining if a new Secret should be created on each tf apply. Useful for scripting purposes | `bool` | n/a | yes |
| <a name="input_data"></a> [data](#input\_data) | (required if create\_new = true) Map of data to include in each Secret (values can be file paths). Data values for rancher2\_secret will be base64encoded as required, therefore do not pass in encoded data | `map(any)` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | (rancher2\_secret only) Description for the Secret | `string` | `null` | no |
| <a name="input_immutable"></a> [immutable](#input\_immutable) | (optional) If set to true, any Secret update will remove and recreate the Secret. This is a beta field enabled by k8s ImmutableEphemeralVolumes feature gate | `string` | `false` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | (optional) A map of labels to add to the Secret | `map(string)` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name for the Secret | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | (optional) The namespace or namespace\_id to create the Secret in | `string` | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | (rancher2\_secret only) ID of the project where the Secret should be created | `string` | `null` | no |
| <a name="input_type"></a> [type](#input\_type) | (optional) The type of the Secret, used to facilitate programmatic handling of Secret data. [More info](https://github.com/kubernetes/api/blob/release-1.20/core/v1/types.go#L5772) about k8s Secret types and expected format | `string` | `"Opaque"` | no |
| <a name="input_use_v2"></a> [use\_v2](#input\_use\_v2) | (required) Flag defining whether to create or retrieve a rancher2\_secret\_v2 or rancher2\_secret | `bool` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_annotations"></a> [annotations](#output\_annotations) | n/a |
| <a name="output_data"></a> [data](#output\_data) | n/a |
| <a name="output_description"></a> [description](#output\_description) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_immutable"></a> [immutable](#output\_immutable) | n/a |
| <a name="output_labels"></a> [labels](#output\_labels) | n/a |
| <a name="output_resource_version"></a> [resource\_version](#output\_resource\_version) | n/a |
| <a name="output_type"></a> [type](#output\_type) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
