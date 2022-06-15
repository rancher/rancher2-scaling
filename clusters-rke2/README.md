# clusters-rke2

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_rancher2"></a> [rancher2](#requirement\_rancher2) | 1.21.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.6.0 |
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | 1.21.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [rancher2_cloud_credential.shared_cred](https://registry.terraform.io/providers/rancher/rancher2/1.21.0/docs/resources/cloud_credential) | resource |
| [rancher2_cluster_v2.rke2](https://registry.terraform.io/providers/rancher/rancher2/1.21.0/docs/resources/cluster_v2) | resource |
| [rancher2_machine_config_v2.aws](https://registry.terraform.io/providers/rancher/rancher2/1.21.0/docs/resources/machine_config_v2) | resource |
| [random_id.index](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zone.selected_az](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zone) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_iam_instance_profile.rancher_iam_full_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_instance_profile) | data source |
| [aws_security_group.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnets.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [rancher2_cloud_credential.existing_cred](https://registry.terraform.io/providers/rancher/rancher2/1.21.0/docs/data-sources/cloud_credential) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | n/a | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"us-west-1"` | no |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | n/a | `string` | `null` | no |
| <a name="input_cluster_labels"></a> [cluster\_labels](#input\_cluster\_labels) | Labels to add to each provisioned cluster | `map(any)` | `{}` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Unique identifier appended to the Rancher url subdomain | `string` | `"rke2"` | no |
| <a name="input_create_credential"></a> [create\_credential](#input\_create\_credential) | Boolean used to determine whether or not to create a credential or use a pre-existing one. Useful for automation | `bool` | `true` | no |
| <a name="input_existing_cloud_cred"></a> [existing\_cloud\_cred](#input\_existing\_cloud\_cred) | (Optional) Name of an existing cloud credential to use. Only use this if create\_credential is false. | `string` | `""` | no |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | n/a | `string` | `null` | no |
| <a name="input_insecure_flag"></a> [insecure\_flag](#input\_insecure\_flag) | Flag used to determine if Rancher is using self-signed invalid certs (using a private CA) | `bool` | `false` | no |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | Version of k8s to use for downstream cluster (RKE2 version string) | `string` | `"v1.21.10+rke2r2"` | no |
| <a name="input_nodes_per_pool"></a> [nodes\_per\_pool](#input\_nodes\_per\_pool) | Number of nodes to create per node pool | `number` | `1` | no |
| <a name="input_rancher_api_url"></a> [rancher\_api\_url](#input\_rancher\_api\_url) | api url for rancher server | `string` | n/a | yes |
| <a name="input_rancher_token_key"></a> [rancher\_token\_key](#input\_rancher\_token\_key) | rancher server API token | `string` | n/a | yes |
| <a name="input_roles_per_pool"></a> [roles\_per\_pool](#input\_roles\_per\_pool) | A list of strings where each element defines the roles for a given node pool via a comma-delimited string. ex: ["control-plane,worker,etcd", "control-plane,worker", "etcd", "etcd"] | `list(string)` | <pre>[<br>  "control-plane,worker,etcd"<br>]</pre> | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | A list of security group names (EC2-Classic) or IDs (default VPC) to associate with | `list(any)` | `[]` | no |
| <a name="input_server_instance_type"></a> [server\_instance\_type](#input\_server\_instance\_type) | Instance type to use for rke2 server | `string` | n/a | yes |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | Size of the storage volume to use in GB | `string` | `"32"` | no |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | Type of storage volume to use | `string` | `"gp2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloud_cred"></a> [cloud\_cred](#output\_cloud\_cred) | n/a |
| <a name="output_roles_map"></a> [roles\_map](#output\_roles\_map) | n/a |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
