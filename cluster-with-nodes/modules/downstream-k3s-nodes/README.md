# downstream-k3s-nodes

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_spot_instance_request.k3s-worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/spot_instance_request) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | n/a | `any` | n/a | yes |
| <a name="input_consul_store"></a> [consul\_store](#input\_consul\_store) | n/a | `any` | n/a | yes |
| <a name="input_install_k3s_version"></a> [install\_k3s\_version](#input\_install\_k3s\_version) | n/a | `any` | n/a | yes |
| <a name="input_instances"></a> [instances](#input\_instances) | n/a | `number` | n/a | yes |
| <a name="input_k3s_agents_per_node"></a> [k3s\_agents\_per\_node](#input\_k3s\_agents\_per\_node) | The number of k3s agents on each ec2 instance | `number` | n/a | yes |
| <a name="input_k3s_endpoint"></a> [k3s\_endpoint](#input\_k3s\_endpoint) | n/a | `any` | n/a | yes |
| <a name="input_k3s_token"></a> [k3s\_token](#input\_k3s\_token) | n/a | `any` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `any` | n/a | yes |
| <a name="input_spot_price"></a> [spot\_price](#input\_spot\_price) | n/a | `any` | n/a | yes |
| <a name="input_worker_instance_type"></a> [worker\_instance\_type](#input\_worker\_instance\_type) | Instance type to use for k3s workers | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
