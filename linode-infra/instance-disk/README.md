# instance-disk

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
| [linode_instance_disk.boot](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/instance_disk) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorized_keys"></a> [authorized\_keys](#input\_authorized\_keys) | (Optional) A list of public SSH keys that will be automatically appended to the root user’s ~/.ssh/authorized\_keys file when deploying from an Image. | `optional(list(string))` | n/a | yes |
| <a name="input_authorized_users"></a> [authorized\_users](#input\_authorized\_users) | (Optional) A list of usernames. If the usernames have associated SSH keys, the keys will be appended to the root user’s ~/.ssh/authorized\_keys file. | `optional(list(string))` | n/a | yes |
| <a name="input_filesystem"></a> [filesystem](#input\_filesystem) | (Optional) The filesystem of this disk. (`raw`, `swap`, `ext3`, `ext4`, `initrd`) | `string` | n/a | yes |
| <a name="input_image"></a> [image](#input\_image) | (Optional) An Image ID to deploy the Linode Disk from. | `string` | n/a | yes |
| <a name="input_label"></a> [label](#input\_label) | (Required) The Disk's label for display purposes only. | `string` | n/a | yes |
| <a name="input_linode_id"></a> [linode\_id](#input\_linode\_id) | (Required) The ID of the Linode to create this Disk under. | `number` | n/a | yes |
| <a name="input_root_pass"></a> [root\_pass](#input\_root\_pass) | (Optional) The root user’s password on a newly-created Linode Disk when deploying from an Image. | `string` | n/a | yes |
| <a name="input_size"></a> [size](#input\_size) | (Required) The size of the Disk in MB. NOTE: Resizing a disk will trigger a Linode reboot. | `string` | n/a | yes |
| <a name="input_stackscript_data"></a> [stackscript\_data](#input\_stackscript\_data) | (Optional) An object containing responses to any User Defined Fields present in the StackScript being deployed to this Disk. Only accepted if `stackscript_id` is given. | `string` | n/a | yes |
| <a name="input_stackscript_id"></a> [stackscript\_id](#input\_stackscript\_id) | (Optional) A StackScript ID that will cause the referenced StackScript to be run during deployment of this Disk. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
