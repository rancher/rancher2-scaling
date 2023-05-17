This module can be used to provision downstream RKE2 clusters via Rancher. This module might create a `tls_private_key` resource that is added to the cluster node(s)
depending on the input variables passed in. Be aware that if the `tls_private_key` resource is created, the key and its contents will be tracked in the terraform state files.
As such, do not use this part of the module's functionality if you plan on sharing your state files or if there is any chance of exposing your state files in an insecure way.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.61.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.4.0 |
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | 1.25.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_key_pair.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [local_file.kube_config](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [rancher2_cloud_credential.shared_cred](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cloud_credential) | resource |
| [rancher2_cluster_v2.rke2](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster_v2) | resource |
| [rancher2_machine_config_v2.aws](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/machine_config_v2) | resource |
| [random_id.index](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [tls_private_key.node_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zone.selected_az](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zone) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_iam_instance_profile.rancher_iam_full_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_instance_profile) | data source |
| [aws_key_pair.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/key_pair) | data source |
| [aws_security_group.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnets.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [rancher2_cloud_credential.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/data-sources/cloud_credential) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_env_vars"></a> [agent\_env\_vars](#input\_agent\_env\_vars) | A list of maps representing Rancher agent environment variables: https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster#agent_env_vars | `list(map(string))` | `null` | no |
| <a name="input_auto_replace_timeout"></a> [auto\_replace\_timeout](#input\_auto\_replace\_timeout) | Time to wait after Cluster becomes Active before deleting nodes that are unreachable | `number` | `null` | no |
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | n/a | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"us-west-1"` | no |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | n/a | `string` | `null` | no |
| <a name="input_cloud_cred_name"></a> [cloud\_cred\_name](#input\_cloud\_cred\_name) | (Optional) Name of cloud credential to use. | `string` | `""` | no |
| <a name="input_cluster_labels"></a> [cluster\_labels](#input\_cluster\_labels) | (Optional) Labels to add to each provisioned cluster | `map(any)` | `{}` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | (Optional) Desired cluster name, if not set then one will be generated | `string` | `""` | no |
| <a name="input_create_credential"></a> [create\_credential](#input\_create\_credential) | Boolean used to determine whether or not to create a credential or use a pre-existing one. Useful for automation | `bool` | `true` | no |
| <a name="input_create_keypair"></a> [create\_keypair](#input\_create\_keypair) | Boolean used to determine whether or not to create a keypair or use a pre-existing one. Useful for easing the process of ssh-ing into clusters | `bool` | `false` | no |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | n/a | `string` | `null` | no |
| <a name="input_insecure_flag"></a> [insecure\_flag](#input\_insecure\_flag) | Flag used to determine if Rancher is using self-signed invalid certs (using a private CA) | `bool` | `false` | no |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | Version of rke2 to use for downstream cluster | `string` | `"v1.21.10+rke2r2"` | no |
| <a name="input_keypair_name"></a> [keypair\_name](#input\_keypair\_name) | Name of a key pair within the specified AWS region to add to the cluster's nodes. If this is set and var.ssh\_key\_path is not set then a new tls\_private\_key resource will be created and used to create a new aws\_key\_pair. These new resources will then be added to the rancher2\_machine\_config\_v2 | `string` | `null` | no |
| <a name="input_name_suffix"></a> [name\_suffix](#input\_name\_suffix) | (Optional) suffix to append to your cloud credential, node template and node pool names | `string` | `""` | no |
| <a name="input_public_key_path"></a> [public\_key\_path](#input\_public\_key\_path) | This variable can only be set if var.ssh\_key\_path is set. Path to the public SSH key file to be used for creating the AWS keypair for accessing the cluster node(s) | `string` | `null` | no |
| <a name="input_rancher_api_url"></a> [rancher\_api\_url](#input\_rancher\_api\_url) | api url for rancher server | `string` | n/a | yes |
| <a name="input_rancher_token_key"></a> [rancher\_token\_key](#input\_rancher\_token\_key) | rancher server API token | `string` | n/a | yes |
| <a name="input_roles_per_pool"></a> [roles\_per\_pool](#input\_roles\_per\_pool) | A list of maps where each element contains keys that define the roles and quantity for a given node pool.<br>  Example: [<br>    {<br>      quantity = 3<br>      etcd = true<br>      control-plane = true<br>      worker = true<br>    }<br>  ] | <pre>list(object({<br>    quantity      = number<br>    etcd          = optional(bool)<br>    control-plane = optional(bool)<br>    worker        = optional(bool)<br>  }))</pre> | <pre>[<br>  {<br>    "control-plane": true,<br>    "etcd": true,<br>    "quantity": 1,<br>    "worker": true<br>  }<br>]</pre> | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | A list of security group names (EC2-Classic) or IDs (default VPC) to associate with | `list(any)` | `[]` | no |
| <a name="input_server_instance_type"></a> [server\_instance\_type](#input\_server\_instance\_type) | Instance type to use for rke2 server | `string` | n/a | yes |
| <a name="input_ssh_key_path"></a> [ssh\_key\_path](#input\_ssh\_key\_path) | Path to the private SSH key file to be used for accessing the cluster node(s) | `string` | `null` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | Size of the storage volume to use in GB | `string` | `"32"` | no |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | Type of storage volume to use | `string` | `"gp2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloud_cred"></a> [cloud\_cred](#output\_cloud\_cred) | n/a |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
