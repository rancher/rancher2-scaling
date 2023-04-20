# cluster-with-nodes

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.45.0 |
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | 1.15.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_downstream-k3s-nodes"></a> [downstream-k3s-nodes](#module\_downstream-k3s-nodes) | ./modules/downstream-k3s-nodes | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_spot_instance_request.k3s-server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/spot_instance_request) | resource |
| [rancher2_cluster.k3s](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_subnet_ids.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_docker_overlay_cidr"></a> [docker\_overlay\_cidr](#input\_docker\_overlay\_cidr) | docker overlay network cidr i.e. 10.0.0.0/8 | `string` | n/a | yes |
| <a name="input_ec2_instances_per_cluster"></a> [ec2\_instances\_per\_cluster](#input\_ec2\_instances\_per\_cluster) | Number of EC2 instances per cluster | `number` | n/a | yes |
| <a name="input_k3s_agents_per_node"></a> [k3s\_agents\_per\_node](#input\_k3s\_agents\_per\_node) | The number of k3s agents on each ec2 instance | `number` | n/a | yes |
| <a name="input_k3s_server_args"></a> [k3s\_server\_args](#input\_k3s\_server\_args) | extra args to pass to k3s server | `string` | `""` | no |
| <a name="input_k3s_token"></a> [k3s\_token](#input\_k3s\_token) | k3s token | `string` | n/a | yes |
| <a name="input_rancher_api_url"></a> [rancher\_api\_url](#input\_rancher\_api\_url) | api url for rancher server | `string` | n/a | yes |
| <a name="input_rancher_token_key"></a> [rancher\_token\_key](#input\_rancher\_token\_key) | rancher server API token | `string` | n/a | yes |
| <a name="input_server_instance_max_price"></a> [server\_instance\_max\_price](#input\_server\_instance\_max\_price) | n/a | `any` | n/a | yes |
| <a name="input_server_instance_type"></a> [server\_instance\_type](#input\_server\_instance\_type) | Instance type to use for k3s server | `string` | n/a | yes |
| <a name="input_worker_instance_max_price"></a> [worker\_instance\_max\_price](#input\_worker\_instance\_max\_price) | n/a | `any` | n/a | yes |
| <a name="input_worker_instance_type"></a> [worker\_instance\_type](#input\_worker\_instance\_type) | Instance type to use for k3s workers | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
