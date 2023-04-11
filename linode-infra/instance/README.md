# instance

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
| [linode_instance.this](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/instance) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorized_keys"></a> [authorized\_keys](#input\_authorized\_keys) | List of SSH keys that are authorized to access the linode(s). Changing authorized\_keys forces the creation of new Linode(s). | `list(string)` | n/a | yes |
| <a name="input_authorized_users"></a> [authorized\_users](#input\_authorized\_users) | List of Linode usernames that are authorized to access the linode(s).  If the usernames have associated SSH keys, the keys will be appended to the root user's ~/.ssh/authorized\_keys file automatically. Changing authorized\_users forces the creation of new Linode(s). | `list(string)` | n/a | yes |
| <a name="input_backups_enabled"></a> [backups\_enabled](#input\_backups\_enabled) | n/a | `any` | n/a | yes |
| <a name="input_booted"></a> [booted](#input\_booted) | If true, then the instance is kept or converted into in a running state. If false, the instance will be shutdown. If unspecified, the Linode's power status will not be managed by the Provider | `bool` | `null` | no |
| <a name="input_disks"></a> [disks](#input\_disks) | value | <pre>list(map({<br>    label      = string<br>    size       = number<br>    id         = string<br>    filesystem = string<br>  }))</pre> | n/a | yes |
| <a name="input_group"></a> [group](#input\_group) | The display group of the Linode(s). | `string` | n/a | yes |
| <a name="input_image"></a> [image](#input\_image) | Linode image ID to deploy all of the linode Disk(s) from. | `string` | n/a | yes |
| <a name="input_interface"></a> [interface](#input\_interface) | A list of network interfaces to be assigned to the Linode on creation. If an explicit config or disk is defined, interfaces must be declared in the config block. | `list(string)` | n/a | yes |
| <a name="input_label"></a> [label](#input\_label) | Linode's label for display purposes, if not provided a default label will be assigned. | `string` | n/a | yes |
| <a name="input_node_count"></a> [node\_count](#input\_node\_count) | Number of nodes to provision. | `number` | n/a | yes |
| <a name="input_private_ip"></a> [private\_ip](#input\_private\_ip) | If true, the created Linode(s) will have private networking enabled, allowing use of the 192.168.128.0/17 network within the Linode's region. It can be enabled on an existing Linode but it can't be disabled. | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | Region the linode(s) are deployed. | `string` | n/a | yes |
| <a name="input_root_pass"></a> [root\_pass](#input\_root\_pass) | The initial password for the root user account of each linode. | `string` | n/a | yes |
| <a name="input_shared_ipv4"></a> [shared\_ipv4](#input\_shared\_ipv4) | n/a | `any` | n/a | yes |
| <a name="input_stackscript_data"></a> [stackscript\_data](#input\_stackscript\_data) | An object containing responses to any User Defined Fields present in the StackScript being deployed to the Linode(s). Only accepted if 'stackscript\_id' is given. The required values depend on the StackScript being deployed. Changing stackscript\_data forces the creation of new Linode(s). | `string` | n/a | yes |
| <a name="input_stackscript_id"></a> [stackscript\_id](#input\_stackscript\_id) | The StackScript to deploy to the Linode(s). If provided, 'image' must also be provided, and must be an Image that is compatible with this StackScript. Changing stackscript\_id forces the creation of new Linode(s). | `string` | n/a | yes |
| <a name="input_swap_size"></a> [swap\_size](#input\_swap\_size) | Swap disk size for each Linode. | `number` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A list of tags applied to the Linode(s). If provided, var.label will be added to each Linode's tags by default. | `list(string)` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | The Linode type for each linode. | `string` | n/a | yes |
| <a name="input_watchdog_enabled"></a> [watchdog\_enabled](#input\_watchdog\_enabled) | n/a | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
