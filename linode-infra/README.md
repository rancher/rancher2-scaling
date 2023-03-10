# linode-infra

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_linode"></a> [linode](#provider\_linode) | 1.29.4 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rancher_firewall"></a> [rancher\_firewall](#module\_rancher\_firewall) | ./firewall | n/a |
| <a name="module_rancher_nodebalancer"></a> [rancher\_nodebalancer](#module\_rancher\_nodebalancer) | ./rancher-nodebalancer | n/a |

## Resources

| Name | Type |
|------|------|
| [linode_domain_record.this](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/domain_record) | resource |
| [linode_instance.this](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/instance) | resource |
| [null_resource.setup](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_pet.identifier](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [linode_domain.this](https://registry.terraform.io/providers/linode/linode/latest/docs/data-sources/domain) | data source |
| [linode_instances.this](https://registry.terraform.io/providers/linode/linode/latest/docs/data-sources/instances) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorized_keys"></a> [authorized\_keys](#input\_authorized\_keys) | List of SSH keys that are authorized to access the linode(s). Changing authorized\_keys forces the creation of new Linode(s). | `list(string)` | `null` | no |
| <a name="input_authorized_users"></a> [authorized\_users](#input\_authorized\_users) | List of Linode usernames that are authorized to access the linode(s).<br>If the usernames have associated SSH keys, the keys will be appended to the root user's ~/.ssh/authorized\_keys file automatically.<br>Changing authorized\_users forces the creation of new Linode(s). | `list(string)` | `null` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain to pull data from via a linode\_domain data source | `string` | n/a | yes |
| <a name="input_group"></a> [group](#input\_group) | The display group of the Linode(s). | `string` | `"terraform-linode"` | no |
| <a name="input_image"></a> [image](#input\_image) | Linode image ID to deploy all of the linode Disk(s) from. | `string` | `"linode/ubuntu18.04"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The Linode type for each linode. | `string` | `"g6-dedicated-4"` | no |
| <a name="input_label"></a> [label](#input\_label) | Linode's label for display purposes, if not provided a default label will be assigned based on either var.subdomain or a randomized identifier. | `string` | `null` | no |
| <a name="input_linode_token"></a> [linode\_token](#input\_linode\_token) | Linode API token | `string` | n/a | yes |
| <a name="input_nlb"></a> [nlb](#input\_nlb) | n/a | `bool` | `true` | no |
| <a name="input_node_count"></a> [node\_count](#input\_node\_count) | Number of nodes to provision. | `number` | `1` | no |
| <a name="input_private_ip"></a> [private\_ip](#input\_private\_ip) | If true, the created Linode(s) will have private networking enabled, allowing use of the 192.168.128.0/17 network within the Linode's region. It can be enabled on an existing Linode but it can't be disabled. | `bool` | `false` | no |
| <a name="input_random_prefix"></a> [random\_prefix](#input\_random\_prefix) | Prefix to be used with random name generation | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region the linode(s) are deployed. | `string` | `"us-east"` | no |
| <a name="input_root_pass"></a> [root\_pass](#input\_root\_pass) | The initial password for the root user account of each linode. | `string` | `null` | no |
| <a name="input_shared_ipv4"></a> [shared\_ipv4](#input\_shared\_ipv4) | A set of IPv4 addresses to be shared with the Instance. These IP addresses can be both private and public, but must be in the same region as the instance. | `list(string)` | `null` | no |
| <a name="input_ssh_key_path"></a> [ssh\_key\_path](#input\_ssh\_key\_path) | Path to the private SSH key file to be used for connecting to the node(s) | `string` | `null` | no |
| <a name="input_stackscript_data"></a> [stackscript\_data](#input\_stackscript\_data) | An object containing responses to any User Defined Fields present in the StackScript being deployed to this Linode. Only accepted if 'stackscript\_id' is given. The required values depend on the StackScript being deployed. This value can not be imported. Changing stackscript\_data forces the creation of a new Linode Instance. | `map(any)` | `null` | no |
| <a name="input_stackscript_id"></a> [stackscript\_id](#input\_stackscript\_id) | The StackScript to deploy to the newly created Linode. If provided, 'image' must also be provided, and must be an Image that is compatible with this StackScript. This value can not be imported. Changing stackscript\_id forces the creation of a new Linode Instance. | `string` | `null` | no |
| <a name="input_subdomain"></a> [subdomain](#input\_subdomain) | The subdomain to create a linode\_domain\_record on. Will be added to tags and labels, etc | `string` | `null` | no |
| <a name="input_swap_size"></a> [swap\_size](#input\_swap\_size) | When deploying from an Image, this field is optional with a Linode API default of 512mb, otherwise it is ignored. This is used to set the swap disk size for the newly-created Linode. | `number` | `512` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A list of tags applied to the Linode(s). If provided, var.label will be added to each Linode's tags by default. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instances"></a> [instances](#output\_instances) | n/a |
| <a name="output_ips"></a> [ips](#output\_ips) | n/a |
| <a name="output_lb_hostname"></a> [lb\_hostname](#output\_lb\_hostname) | n/a |
| <a name="output_lb_ipv4"></a> [lb\_ipv4](#output\_lb\_ipv4) | n/a |
| <a name="output_lb_ipv6"></a> [lb\_ipv6](#output\_lb\_ipv6) | n/a |
| <a name="output_private"></a> [private](#output\_private) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
