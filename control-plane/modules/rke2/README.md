# rke2

### **NOTE:** This module currently depends on having a valid IAM instance profile with s3 (bucket and object) create, list, and destroy permissions
---

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_infra_rke2"></a> [aws\_infra\_rke2](#module\_aws\_infra\_rke2) | git::https://github.com/git-ival/rke2-aws-tf.git// | refactor-nodepool-setup |
| <a name="module_rke2_monitor_pool"></a> [rke2\_monitor\_pool](#module\_rke2\_monitor\_pool) | git::https://github.com/git-ival/rke2-aws-tf.git//modules/agent-nodepool | refactor-nodepool-setup |

## Resources

| Name | Type |
|------|------|
| [aws_lb_listener.server-port_443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.server-port_80](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.server_443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.server_80](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_route53_record.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.ingress_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.rancher](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_route53_zone.dns_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_s3_object.kube_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_object) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami"></a> [ami](#input\_ami) | AMI to use for rke2 server instances | `string` | `null` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `any` | n/a | yes |
| <a name="input_extra_server_security_groups"></a> [extra\_server\_security\_groups](#input\_extra\_server\_security\_groups) | IDs for additional security groups to attach to rke2 server instances | `list(any)` | `[]` | no |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | String that defines the name of the IAM Instance Profile that grants S3 access to the EC2 instances | `string` | `""` | no |
| <a name="input_install_docker_version"></a> [install\_docker\_version](#input\_install\_docker\_version) | Version of Docker to install | `string` | `"20.10"` | no |
| <a name="input_internal_lb"></a> [internal\_lb](#input\_internal\_lb) | n/a | `bool` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name used for the cluster and various resources, used as a prefix for individual instance names | `string` | `"rancher-scaling"` | no |
| <a name="input_rke2_channel"></a> [rke2\_channel](#input\_rke2\_channel) | Release channel to use for fetching RKE2 download URL, defaults to stable | `string` | `"stable"` | no |
| <a name="input_rke2_version"></a> [rke2\_version](#input\_rke2\_version) | Version to use for RKE2 server nodes, defaults to latest on the specified release channel | `string` | `""` | no |
| <a name="input_secrets_encryption"></a> [secrets\_encryption](#input\_secrets\_encryption) | (Optional) Boolean that determines if secrets-encryption should be enabled | `bool` | `false` | no |
| <a name="input_server_instance_ssh_user"></a> [server\_instance\_ssh\_user](#input\_server\_instance\_ssh\_user) | Username for sshing into instances | `string` | `"ubuntu"` | no |
| <a name="input_server_instance_type"></a> [server\_instance\_type](#input\_server\_instance\_type) | n/a | `string` | `"m5.large"` | no |
| <a name="input_server_node_count"></a> [server\_node\_count](#input\_server\_node\_count) | Number of server nodes to launch (one of these nodes will be the leader node) | `number` | `1` | no |
| <a name="input_setup_monitoring_agent"></a> [setup\_monitoring\_agent](#input\_setup\_monitoring\_agent) | n/a | `bool` | `true` | no |
| <a name="input_ssh_key_path"></a> [ssh\_key\_path](#input\_ssh\_key\_path) | Path to the ssh\_key file to be used for connecting to the nodes | `string` | `null` | no |
| <a name="input_ssh_keys"></a> [ssh\_keys](#input\_ssh\_keys) | SSH keys to inject into Rancher instances | `list(any)` | `[]` | no |
| <a name="input_subdomain"></a> [subdomain](#input\_subdomain) | n/a | `any` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnet ids. | `list(any)` | `[]` | no |
| <a name="input_user"></a> [user](#input\_user) | n/a | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC to use | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_data"></a> [cluster\_data](#output\_cluster\_data) | Map of cluster data required by agent pools for joining cluster, do not modify this |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
