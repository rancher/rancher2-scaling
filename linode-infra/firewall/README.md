# firewall

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
| [linode_firewall.this](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/firewall) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_disabled"></a> [disabled](#input\_disabled) | If true, the Firewall's rules are not enforced | `bool` | `false` | no |
| <a name="input_inbound_policy"></a> [inbound\_policy](#input\_inbound\_policy) | The default behavior for inbound traffic. This setting can be overridden by updating the inbound.action property of the Firewall Rule | `string` | n/a | yes |
| <a name="input_inbound_rules"></a> [inbound\_rules](#input\_inbound\_rules) | A list of firewall rules (as maps) that specifies what inbound network traffic is allowed | <pre>list(object({<br>    label    = string<br>    action   = string<br>    protocol = string<br>    ports    = string<br>    ipv4     = list(string)<br>    ipv6     = list(string)<br>  }))</pre> | `null` | no |
| <a name="input_label"></a> [label](#input\_label) | This Firewall's unique label | `string` | n/a | yes |
| <a name="input_linodes"></a> [linodes](#input\_linodes) | A list of IDs of Linodes this Firewall should govern it's network traffic for | `list(string)` | n/a | yes |
| <a name="input_outbound_policy"></a> [outbound\_policy](#input\_outbound\_policy) | The default behavior for inbound traffic. This setting can be overridden by updating the inbound.action property of the Firewall Rule | `string` | n/a | yes |
| <a name="input_outbound_rules"></a> [outbound\_rules](#input\_outbound\_rules) | A list of firewall rules (as maps) that specifies what outbound network traffic is allowed | <pre>list(object({<br>    label    = string<br>    action   = string<br>    protocol = string<br>    ports    = string<br>    ipv4     = list(string)<br>    ipv6     = list(string)<br>  }))</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A list of tags applied to the Kubernetes cluster. Tags are for organizational purposes only | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_devices"></a> [devices](#output\_devices) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_status"></a> [status](#output\_status) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
