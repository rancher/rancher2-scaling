# aws

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.55.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.3.0 |
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | 1.25.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloud_credential"></a> [cloud\_credential](#module\_cloud\_credential) | ../../rancher-cluster-operations/rancher-cloud-credential | n/a |
| <a name="module_cluster_v1"></a> [cluster\_v1](#module\_cluster\_v1) | ../../rancher-cluster-operations/rancher-cluster/v1 | n/a |
| <a name="module_node_template"></a> [node\_template](#module\_node\_template) | ../../rancher-cluster-operations/rancher-node-template | n/a |
| <a name="module_rancher_monitoring"></a> [rancher\_monitoring](#module\_rancher\_monitoring) | ../../rancher-cluster-operations/charts/rancher-monitoring | n/a |

## Resources

| Name | Type |
|------|------|
| [local_file.kube_config](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [rancher2_cluster_sync.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster_sync) | resource |
| [rancher2_node_pool.np](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/node_pool) | resource |
| [random_id.index](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zone.selected_az](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zone) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_subnets.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_env_vars"></a> [agent\_env\_vars](#input\_agent\_env\_vars) | A list of maps representing Rancher agent environment variables: https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster#agent_env_vars | `list(map(string))` | `null` | no |
| <a name="input_auto_replace_timeout"></a> [auto\_replace\_timeout](#input\_auto\_replace\_timeout) | Time to wait after Cluster becomes Active before deleting nodes that are unreachable | `number` | n/a | yes |
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | n/a | `string` | `null` | no |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | n/a | `string` | `null` | no |
| <a name="input_cloud_cred_name"></a> [cloud\_cred\_name](#input\_cloud\_cred\_name) | (Optional) Name to use for the cloud credential. | `string` | `""` | no |
| <a name="input_cluster_labels"></a> [cluster\_labels](#input\_cluster\_labels) | (Optional) Labels to add to each provisioned cluster | `map(any)` | `{}` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | (Optional) Desired cluster name, if not set then one will be generated | `string` | `""` | no |
| <a name="input_create_node_reqs"></a> [create\_node\_reqs](#input\_create\_node\_reqs) | Flag defining if a cloud credential & node template should be created on tf apply. Useful for scripting purposes | `bool` | `true` | no |
| <a name="input_enable_cri_dockerd"></a> [enable\_cri\_dockerd](#input\_enable\_cri\_dockerd) | (Optional) Enable/disable using cri-dockerd | `bool` | `false` | no |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | n/a | `string` | `null` | no |
| <a name="input_image"></a> [image](#input\_image) | Specific AWS AMI or AMI name filter to use | `string` | `"ubuntu-minimal/images/*/ubuntu-bionic-18.04-*"` | no |
| <a name="input_insecure_flag"></a> [insecure\_flag](#input\_insecure\_flag) | Flag used to determine if Rancher is using self-signed invalid certs (using a private CA) | `bool` | `false` | no |
| <a name="input_install_docker_version"></a> [install\_docker\_version](#input\_install\_docker\_version) | The version of docker to install. Available docker versions can be found at: https://github.com/rancher/install-docker | `string` | `"20.10"` | no |
| <a name="input_install_monitoring"></a> [install\_monitoring](#input\_install\_monitoring) | Boolean that defines whether or not to install rancher-monitoring | `bool` | `false` | no |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | Version of k8s to use for downstream cluster (RKE1 version string) | `string` | `"v1.22.9-rancher1-1"` | no |
| <a name="input_kube_api_debugging"></a> [kube\_api\_debugging](#input\_kube\_api\_debugging) | A flag defining if more verbose logging should be enabled for the kube\_api service | `bool` | `false` | no |
| <a name="input_monitoring_version"></a> [monitoring\_version](#input\_monitoring\_version) | Version of Monitoring v2 to install - Do not include the v prefix. | `string` | `null` | no |
| <a name="input_name_suffix"></a> [name\_suffix](#input\_name\_suffix) | (Optional) suffix to append to your cloud credential, node template and node pool names | `string` | `""` | no |
| <a name="input_node_template_engine_fields"></a> [node\_template\_engine\_fields](#input\_node\_template\_engine\_fields) | A map of one-to-one keys with the various engine settings available on the `rancher2_node_template` resource: https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/node_template#engine_storage_driver | <pre>object({<br>    engine_env               = optional(map(string), null)<br>    engine_insecure_registry = optional(list(string), null)<br>    engine_install_url       = optional(string, null)<br>    engine_label             = optional(map(string), null)<br>    engine_opt               = optional(map(string), null)<br>    engine_registry_mirror   = optional(list(string), null)<br>    engine_storage_driver    = optional(string, null)<br>  })</pre> | `null` | no |
| <a name="input_node_template_name"></a> [node\_template\_name](#input\_node\_template\_name) | (Optional) Name to use for the node template. | `string` | `""` | no |
| <a name="input_rancher_api_url"></a> [rancher\_api\_url](#input\_rancher\_api\_url) | api url for rancher server | `string` | n/a | yes |
| <a name="input_rancher_charts_branch"></a> [rancher\_charts\_branch](#input\_rancher\_charts\_branch) | The github branch for the desired Rancher chart version | `string` | `"release-v2.6"` | no |
| <a name="input_rancher_token_key"></a> [rancher\_token\_key](#input\_rancher\_token\_key) | rancher server API token | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Cloud provider-specific region string. Defaults to an AWS-specific region | `string` | `"us-west-1"` | no |
| <a name="input_roles_per_pool"></a> [roles\_per\_pool](#input\_roles\_per\_pool) | A list of maps where each element contains keys that define the roles and quantity for a given node pool.<br>  Example: [<br>    {<br>      quantity = 3<br>      etcd = true<br>      control-plane = true<br>      worker = true<br>    }<br>  ] | <pre>list(object({<br>    quantity      = number<br>    etcd          = optional(bool)<br>    control-plane = optional(bool)<br>    worker        = optional(bool)<br>  }))</pre> | <pre>[<br>  {<br>    "control-plane": true,<br>    "etcd": true,<br>    "quantity": 1,<br>    "worker": true<br>  }<br>]</pre> | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | A list of security group names (EC2-Classic) or IDs (default VPC) to associate with | `list(any)` | `[]` | no |
| <a name="input_server_instance_type"></a> [server\_instance\_type](#input\_server\_instance\_type) | Cloud provider-specific instance type string to use for rke1 server | `string` | n/a | yes |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | Size of the storage volume to use in GB | `string` | `"32"` | no |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | Type of storage volume to use | `string` | `"gp2"` | no |
| <a name="input_wait_for_active"></a> [wait\_for\_active](#input\_wait\_for\_active) | Flag that determines if a cluster\_sync resource should be used (this will block until the cluster is active or a timeout is reached) | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | n/a |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
| <a name="output_create_node_reqs"></a> [create\_node\_reqs](#output\_create\_node\_reqs) | n/a |
| <a name="output_cred_name"></a> [cred\_name](#output\_cred\_name) | n/a |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | n/a |
| <a name="output_nt_name"></a> [nt\_name](#output\_nt\_name) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
