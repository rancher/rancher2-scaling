# bulk-components

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | 2.2.3 |
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | 1.25.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_cloud_credentials"></a> [aws\_cloud\_credentials](#module\_aws\_cloud\_credentials) | ../rancher-cloud-credential | n/a |
| <a name="module_linode_cloud_credentials"></a> [linode\_cloud\_credentials](#module\_linode\_cloud\_credentials) | ../rancher-cloud-credential | n/a |
| <a name="module_secrets"></a> [secrets](#module\_secrets) | ../rancher-secret | n/a |
| <a name="module_secrets_v2"></a> [secrets\_v2](#module\_secrets\_v2) | ../rancher-secret | n/a |

## Resources

| Name | Type |
|------|------|
| [local_file.aws_credentials](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.linode_credentials](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.projects](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.secrets](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.secrets_v2](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.tokens](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [rancher2_cluster_role_template_binding.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster_role_template_binding) | resource |
| [rancher2_global_role.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/global_role) | resource |
| [rancher2_global_role_binding.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/global_role_binding) | resource |
| [rancher2_namespace.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/namespace) | resource |
| [rancher2_project.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/project) | resource |
| [rancher2_project.user_roles](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/project) | resource |
| [rancher2_project_role_template_binding.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/project_role_template_binding) | resource |
| [rancher2_role_template.cluster](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/role_template) | resource |
| [rancher2_role_template.project](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/role_template) | resource |
| [rancher2_token.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/token) | resource |
| [rancher2_user.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/user) | resource |
| [random_id.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [rancher2_cluster.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/data-sources/cluster) | data source |
| [rancher2_namespace.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/data-sources/namespace) | data source |
| [rancher2_project.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/data-sources/project) | data source |
| [rancher2_user.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/data-sources/user) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | AWS access key matching aws\_secret\_key | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region string | `string` | `"us-west-1"` | no |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | AWS secret key matching aws\_access\_key | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of rancher2\_cluster to operate on. Not used for the creation of clusters | `string` | `"local"` | no |
| <a name="input_create_new_users"></a> [create\_new\_users](#input\_create\_new\_users) | n/a | `bool` | `true` | no |
| <a name="input_linode_token"></a> [linode\_token](#input\_linode\_token) | Linode API token with necessary permissions | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Name of rancher2\_namespace to operate on. Not used for the creation of namespaces | `string` | `"default"` | no |
| <a name="input_num_aws_credentials"></a> [num\_aws\_credentials](#input\_num\_aws\_credentials) | n/a | `number` | `0` | no |
| <a name="input_num_linode_credentials"></a> [num\_linode\_credentials](#input\_num\_linode\_credentials) | n/a | `number` | `0` | no |
| <a name="input_num_namespaces"></a> [num\_namespaces](#input\_num\_namespaces) | n/a | `number` | `0` | no |
| <a name="input_num_projects"></a> [num\_projects](#input\_num\_projects) | n/a | `number` | `0` | no |
| <a name="input_num_secrets"></a> [num\_secrets](#input\_num\_secrets) | n/a | `number` | `0` | no |
| <a name="input_num_tokens"></a> [num\_tokens](#input\_num\_tokens) | n/a | `number` | `0` | no |
| <a name="input_num_users"></a> [num\_users](#input\_num\_users) | Number of new users to create, not to be used with var.users | `number` | `0` | no |
| <a name="input_output_local_file"></a> [output\_local\_file](#input\_output\_local\_file) | Boolean flag that controls if the created component lists will be output to a local file. Recommendation is to set this to true. | `bool` | `false` | no |
| <a name="input_output_stdout"></a> [output\_stdout](#input\_output\_stdout) | Boolean flag that controls if the created component lists will be output to stdout. Recommendation is not to output to stdout. | `bool` | `false` | no |
| <a name="input_project"></a> [project](#input\_project) | Name of rancher2\_project to operate on. Not used for the creation of projects | `string` | `"Default"` | no |
| <a name="input_rancher_api_url"></a> [rancher\_api\_url](#input\_rancher\_api\_url) | api url for rancher server | `string` | n/a | yes |
| <a name="input_rancher_token_key"></a> [rancher\_token\_key](#input\_rancher\_token\_key) | rancher server API token | `string` | n/a | yes |
| <a name="input_secret_data"></a> [secret\_data](#input\_secret\_data) | Map of key-values or file to store in each Secret | `any` | <pre>{<br>  "bulk_secret": "True"<br>}</pre> | no |
| <a name="input_use_v2"></a> [use\_v2](#input\_use\_v2) | Flag to determine whether or not to use the v2 version of a given resource | `bool` | `false` | no |
| <a name="input_user_cluster_binding"></a> [user\_cluster\_binding](#input\_user\_cluster\_binding) | n/a | `bool` | `false` | no |
| <a name="input_user_global_binding"></a> [user\_global\_binding](#input\_user\_global\_binding) | n/a | `bool` | `false` | no |
| <a name="input_user_name_ref_pattern"></a> [user\_name\_ref\_pattern](#input\_user\_name\_ref\_pattern) | n/a | `string` | `""` | no |
| <a name="input_user_password"></a> [user\_password](#input\_user\_password) | Password to use for created users | `string` | n/a | yes |
| <a name="input_user_project_binding"></a> [user\_project\_binding](#input\_user\_project\_binding) | n/a | `bool` | `false` | no |
| <a name="input_users"></a> [users](#input\_users) | A list of maps with at least a 'name' or username' field, not to be used with var.num\_users | <pre>list(object({<br>    name     = string<br>    username = optional(string)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_cloud_credentials"></a> [aws\_cloud\_credentials](#output\_aws\_cloud\_credentials) | n/a |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | n/a |
| <a name="output_linode_cloud_credentials"></a> [linode\_cloud\_credentials](#output\_linode\_cloud\_credentials) | n/a |
| <a name="output_projects"></a> [projects](#output\_projects) | n/a |
| <a name="output_secrets"></a> [secrets](#output\_secrets) | n/a |
| <a name="output_secrets_v2"></a> [secrets\_v2](#output\_secrets\_v2) | n/a |
| <a name="output_tokens"></a> [tokens](#output\_tokens) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
