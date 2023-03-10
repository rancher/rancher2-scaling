# instance-config

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
| [linode_instance_config.this](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/instance_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_booted"></a> [booted](#input\_booted) | (Optional) If true, the Linode will be booted into this config. If another config is booted, the Linode will be rebooted into this config. If false, the Linode will be shutdown only if it is currently booted into this config. If undefined, the config will alter the boot status of the Linode. | `optional(bool)` | n/a | yes |
| <a name="input_comments"></a> [comments](#input\_comments) | (Optional) Optional field for arbitrary User comments on this Config. | `optional(string)` | n/a | yes |
| <a name="input_devices"></a> [devices](#input\_devices) | (Optional) A list of maps defining the configuration for one or more devices. The SDA-SDH slots, represent the Linux block device nodes for the first 8 disks attached to the Linode.  Each device must be suplied sequentially.  The device can be either a Disk or a Volume identified by `disk_id` or `volume_id`. Only one disk identifier is permitted per slot. Devices mapped from `sde` through `sdh` are unavailable in `"fullvirt"` `virt_mode`.<br>  * `volume_id` - (Optional) The Volume ID to map to this `device` slot.<br>  * `disk_id` - (Optional) The Disk ID to map to this `device` slot | <pre>optional(list(map(<br>    {<br>      volume_id = optional(string)<br>      disk_id   = optional(string)<br>    }<br>  )))</pre> | n/a | yes |
| <a name="input_helpers"></a> [helpers](#input\_helpers) | (Optional) A map defining the configuration for one or more helpers. The following attributes are available on helpers:<br>  * `devtmpfs_automount` - (Optional) Populates the /dev directory early during boot without udev. (default `true`)<br>  * `distro` - (Optional) Helps maintain correct inittab/upstart console device. (default `true`)<br>  * `modules_dep` - (Optional) Creates a modules dependency file for the Kernel you run. (default `true`)<br>  * `network` - (Optional) Automatically configures static networking. (default `true`)<br>  * `updatedb_disabled` - (Optional) Disables updatedb cron job to avoid disk thrashing. (default `true`) | <pre>optional(map(<br>    {<br>      devtmpfs_automount = optional(bool, true)<br>      distro             = optional(bool, true)<br>      modules_dep        = optional(bool, true)<br>      network            = optional(bool, true)<br>      updatedb_disabled  = optional(bool, true)<br>    }<br>  ))</pre> | n/a | yes |
| <a name="input_interfaces"></a> [interfaces](#input\_interfaces) | (Optional) A list of maps defining the configuration for one or more interfaces. The following attributes are available on interface:<br>  * `purpose` - (Required) The type of interface. (`public`, `vlan`)<br>  * `ipam_address` - (Optional) This Network Interface’s private IP address in Classless Inter-Domain Routing (CIDR) notation. (e.g. `10.0.0.1/24`)<br>  * `label` - (Optional) The name of this interface. | <pre>optional(list(map(<br>    {<br>      purpose      = string<br>      ipam_address = optional(string)<br>      label        = optional(string)<br>    }<br>  )))</pre> | n/a | yes |
| <a name="input_kernel"></a> [kernel](#input\_kernel) | (Optional) A Kernel ID to boot a Linode with. (default `linode/latest-64bit`) | `optional(string, "linode/latest-64bit")` | `"linode/latest-64bit"` | no |
| <a name="input_label"></a> [label](#input\_label) | (Required) The Config’s label for display purposes only. | `string` | n/a | yes |
| <a name="input_linode_id"></a> [linode\_id](#input\_linode\_id) | (Required) The ID of the Linode to create this configuration profile under. | `number` | n/a | yes |
| <a name="input_memory_limit"></a> [memory\_limit](#input\_memory\_limit) | (Optional) The memory limit of the Config. Defaults to the total ram of the Linode. | `optional(number)` | n/a | yes |
| <a name="input_root_device"></a> [root\_device](#input\_root\_device) | (Optional) The root device to boot. (default `/dev/sda`) | `optional(string)` | n/a | yes |
| <a name="input_run_level"></a> [run\_level](#input\_run\_level) | (Optional) Defines the state of your Linode after booting. (`default`, `single`, `binbash`) | `optional(string)` | n/a | yes |
| <a name="input_virt_mode"></a> [virt\_mode](#input\_virt\_mode) | (Optional) Controls the virtualization mode. (`paravirt`, `fullvirt`) | `optional(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
