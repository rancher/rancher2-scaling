# rancher-nodebalancer

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_linode"></a> [linode](#provider\_linode) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [linode_nodebalancer.this](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/nodebalancer) | resource |
| [linode_nodebalancer_config.this](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/nodebalancer_config) | resource |
| [linode_nodebalancer_node.nlb_443](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/nodebalancer_node) | resource |
| [linode_nodebalancer_node.nlb_6443](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/nodebalancer_node) | resource |
| [linode_nodebalancer_node.nlb_80](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/nodebalancer_node) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_label"></a> [label](#input\_label) | The label of the Linode NodeBalancer | `string` | `null` | no |
| <a name="input_linodes"></a> [linodes](#input\_linodes) | A list of objects containing the label and private\_ip\_address of each linode to be added to the nodebalancer. Can pass a list of data.linode\_instances as well | <pre>list(object({<br>    label              = string<br>    private_ip_address = string<br>  }))</pre> | n/a | yes |
| <a name="input_node_count"></a> [node\_count](#input\_node\_count) | Number of linodes to add to the nodebalancer | `number` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region where this NodeBalancer will be deployed.  Examples are "us-east", "us-west", "ap-south", etc. See all regions [here](https://api.linode.com/v4/regions).  *Changing `region` forces the creation of a new Linode NodeBalancer.* | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A list of tags applied to this object. Tags are for organizational purposes only. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_created"></a> [created](#output\_created) | n/a |
| <a name="output_hostname"></a> [hostname](#output\_hostname) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_ipv4"></a> [ipv4](#output\_ipv4) | n/a |
| <a name="output_ipv6"></a> [ipv6](#output\_ipv6) | n/a |
| <a name="output_transfer"></a> [transfer](#output\_transfer) | n/a |
| <a name="output_updated"></a> [updated](#output\_updated) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
