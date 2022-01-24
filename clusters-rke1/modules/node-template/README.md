# node-template

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | 1.21.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [rancher2_cloud_credential.aws_cloud_cred](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cloud_credential) | resource |
| [rancher2_node_template.aws_nt](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/node_template) | resource |
| [rancher2_cloud_credential.aws_cloud_cred](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/data-sources/cloud_credential) | data source |
| [rancher2_node_template.aws_nt](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/data-sources/node_template) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | n/a | `string` | `null` | no |
| <a name="input_aws_ami"></a> [aws\_ami](#input\_aws\_ami) | n/a | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"us-west-1"` | no |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | n/a | `string` | `null` | no |
| <a name="input_cloud_cred_name"></a> [cloud\_cred\_name](#input\_cloud\_cred\_name) | n/a | `string` | `null` | no |
| <a name="input_create_node_reqs"></a> [create\_node\_reqs](#input\_create\_node\_reqs) | Flag defining if a cloud credential & node template should be created on each tf apply. Useful for scripting purposes | `bool` | `true` | no |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | n/a | `string` | `null` | no |
| <a name="input_install_docker_version"></a> [install\_docker\_version](#input\_install\_docker\_version) | The version of docker to install. Available docker versions can be found at: https://github.com/rancher/install-docker | `string` | `"20.10"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type to use for rke1 server | `string` | n/a | yes |
| <a name="input_node_template_name"></a> [node\_template\_name](#input\_node\_template\_name) | n/a | `string` | `null` | no |
| <a name="input_root_size"></a> [root\_size](#input\_root\_size) | Size of the storage volume to use in GB | `string` | `"32"` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | A list of security group names (EC2-Classic) or IDs (default VPC) to associate with | `list(any)` | `[]` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | n/a | `string` | `null` | no |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | Type of storage volume to use | `string` | `"gp2"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | `null` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | n/a | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_node_template"></a> [node\_template](#output\_node\_template) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
