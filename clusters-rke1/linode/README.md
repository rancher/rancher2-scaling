# linode

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloud_credential"></a> [cloud\_credential](#module\_cloud\_credential) | ../../rancher-cluster-operations/rancher-cloud-credential | n/a |
| <a name="module_cluster_v1"></a> [cluster\_v1](#module\_cluster\_v1) | ../../rancher-cluster-operations/rancher-cluster/v1 | n/a |
| <a name="module_node_template"></a> [node\_template](#module\_node\_template) | ../../rancher-cluster-operations/rancher-node-template | n/a |

## Resources

| Name | Type |
|------|------|
| [rancher2_node_pool.np](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/node_pool) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_labels"></a> [cluster\_labels](#input\_cluster\_labels) | Labels to add to each provisioned cluster | `map(any)` | `{}` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Unique cluster identifier appended to the Rancher url subdomain | `string` | `"load-testing"` | no |
| <a name="input_create_node_reqs"></a> [create\_node\_reqs](#input\_create\_node\_reqs) | Flag defining if a cloud credential & node template should be created on tf apply. Useful for scripting purposes | `bool` | `true` | no |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | n/a | `string` | `null` | no |
| <a name="input_image"></a> [image](#input\_image) | Linode-specific image name string | `string` | `"linode/ubuntu18.04"` | no |
| <a name="input_insecure_flag"></a> [insecure\_flag](#input\_insecure\_flag) | Flag used to determine if Rancher is using self-signed invalid certs (using a private CA) | `bool` | `false` | no |
| <a name="input_install_docker_version"></a> [install\_docker\_version](#input\_install\_docker\_version) | The version of docker to install. Available docker versions can be found at: https://github.com/rancher/install-docker | `string` | `"20.10"` | no |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | Version of k8s to use for downstream cluster (RKE1 version string) | `string` | `"v1.22.9-rancher1-1"` | no |
| <a name="input_linode_token"></a> [linode\_token](#input\_linode\_token) | n/a | `string` | `null` | no |
| <a name="input_name_suffix"></a> [name\_suffix](#input\_name\_suffix) | (Optional) suffix to append to your cloud credential, node template and node pool names | `string` | `null` | no |
| <a name="input_node_pool_count"></a> [node\_pool\_count](#input\_node\_pool\_count) | Number of node pools to create | `number` | `3` | no |
| <a name="input_nodes_per_pool"></a> [nodes\_per\_pool](#input\_nodes\_per\_pool) | Number of nodes to create per node pool | `number` | `1` | no |
| <a name="input_rancher_api_url"></a> [rancher\_api\_url](#input\_rancher\_api\_url) | api url for rancher server | `string` | n/a | yes |
| <a name="input_rancher_token_key"></a> [rancher\_token\_key](#input\_rancher\_token\_key) | rancher server API token | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Cloud provider-specific region string. Defaults to an AWS-specific region | `string` | `"us-west-1"` | no |
| <a name="input_server_instance_type"></a> [server\_instance\_type](#input\_server\_instance\_type) | Cloud provider-specific instance type string to use for rke1 server | `string` | n/a | yes |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | Size of the storage volume to use in GB | `string` | `"32"` | no |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | Type of storage volume to use | `string` | `"gp2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_create_node_reqs"></a> [create\_node\_reqs](#output\_create\_node\_reqs) | n/a |
| <a name="output_cred_name"></a> [cred\_name](#output\_cred\_name) | n/a |
| <a name="output_nt_name"></a> [nt\_name](#output\_nt\_name) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
