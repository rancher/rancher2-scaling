# aws-infra

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_cloudinit"></a> [cloudinit](#provider\_cloudinit) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.rke1_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_launch_template.rke1_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_lb.lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb.server-public-lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb.server_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.port_443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.port_80](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.server-port_443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.server-port_80](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.server_port_6443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.agent-443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.agent-80](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.server-443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.server-6443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.server-80](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_route53_record.rancher](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.rke1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.ingress_egress_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.rke1_server_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.self_dockerd_tls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.self_etcd_comms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.self_ingress_liveness_readiness](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.self_kubelet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.self_nodeport_range](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.self_prom_metrics_linux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.self_prom_metrics_windows](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.self_rke1_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.self_vxlan](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.self_vxlan_liveness_readiness](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ssh_rke1_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [null_resource.wait_for_bootstrap](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_instance_profile.rancher_s3_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_instance_profile) | data source |
| [aws_instances.nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instances) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.dns_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_subnets.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [cloudinit_config.rke1_server](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_azs"></a> [aws\_azs](#input\_aws\_azs) | List of AWS Availability Zones in the VPC | `list(any)` | `null` | no |
| <a name="input_create_external_nlb"></a> [create\_external\_nlb](#input\_create\_external\_nlb) | Boolean that defines whether or not to create an external load balancer | `bool` | `true` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | `""` | no |
| <a name="input_extra_server_security_groups"></a> [extra\_server\_security\_groups](#input\_extra\_server\_security\_groups) | Additional security groups to attach to rke1 server instances | `list(any)` | `[]` | no |
| <a name="input_install_docker_version"></a> [install\_docker\_version](#input\_install\_docker\_version) | Version of Docker to install | `string` | `"20.10"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name used for various resources, used as a prefix for individual instance names | `string` | `"rancher-scaling"` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of private subnet ids. | `list(any)` | `[]` | no |
| <a name="input_private_subnets_cidr_blocks"></a> [private\_subnets\_cidr\_blocks](#input\_private\_subnets\_cidr\_blocks) | List of cidr\_blocks of private subnets | `list(any)` | `[]` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | List of public subnet ids. | `list(any)` | `[]` | no |
| <a name="input_r53_domain"></a> [r53\_domain](#input\_r53\_domain) | DNS domain for Route53 zone (defaults to domain if unset) | `string` | `""` | no |
| <a name="input_s3_instance_profile"></a> [s3\_instance\_profile](#input\_s3\_instance\_profile) | Optional: String that defines the name of the IAM Instance Profile that grants S3 access to the EC2 instances. Required if 'byo\_certs\_bucket\_path' is set | `string` | `""` | no |
| <a name="input_server_image_id"></a> [server\_image\_id](#input\_server\_image\_id) | AMI to use for rke1 server instances | `string` | `null` | no |
| <a name="input_server_instance_ssh_user"></a> [server\_instance\_ssh\_user](#input\_server\_instance\_ssh\_user) | Username for sshing into instances | `string` | `"ubuntu"` | no |
| <a name="input_server_instance_type"></a> [server\_instance\_type](#input\_server\_instance\_type) | n/a | `string` | `"m5.large"` | no |
| <a name="input_server_node_count"></a> [server\_node\_count](#input\_server\_node\_count) | Number of server nodes to launch | `number` | `1` | no |
| <a name="input_ssh_key_path"></a> [ssh\_key\_path](#input\_ssh\_key\_path) | Path to the ssh\_key file to be used for connecting to the nodes | `string` | `null` | no |
| <a name="input_ssh_keys"></a> [ssh\_keys](#input\_ssh\_keys) | SSH keys to inject into Rancher instances | `list(any)` | `[]` | no |
| <a name="input_subdomain"></a> [subdomain](#input\_subdomain) | subdomain to host rancher on, instead of using `var.name` | `string` | `null` | no |
| <a name="input_use_route53"></a> [use\_route53](#input\_use\_route53) | Configures whether to use route\_53 DNS or not | `bool` | `true` | no |
| <a name="input_user"></a> [user](#input\_user) | n/a | `string` | n/a | yes |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | Size of shared EBS volume allocated for the nodes | `string` | `"50"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The vpc id that Rancher should use | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_external_lb_dns_name"></a> [external\_lb\_dns\_name](#output\_external\_lb\_dns\_name) | n/a |
| <a name="output_nodes_ids"></a> [nodes\_ids](#output\_nodes\_ids) | n/a |
| <a name="output_nodes_private_ips"></a> [nodes\_private\_ips](#output\_nodes\_private\_ips) | n/a |
| <a name="output_nodes_public_ips"></a> [nodes\_public\_ips](#output\_nodes\_public\_ips) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
