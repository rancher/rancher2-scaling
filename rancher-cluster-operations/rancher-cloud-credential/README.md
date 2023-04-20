# rancher-cloud-credential

This component module can be used to create or retrieve a `rancher2_cloud_credential` resource.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_rancher2"></a> [rancher2](#requirement\_rancher2) | >= 1.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | 1.23.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [rancher2_cloud_credential.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cloud_credential) | resource |
| [rancher2_cloud_credential.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/data-sources/cloud_credential) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | A string defining which cloud provider to dynamically create a rancher2\_cloud\_credential for | `string` | n/a | yes |
| <a name="input_create_new"></a> [create\_new](#input\_create\_new) | Flag defining if a new rancher2\_cloud\_credential should be created on each tf apply. Useful for scripting purposes | `bool` | `true` | no |
| <a name="input_credential_config"></a> [credential\_config](#input\_credential\_config) | An object containing your cloud provider's specific rancher2\_cloud\_credential config fields in order to dynamically map to them | <pre>object({<br>    access_key = optional(string)<br>    secret_key = optional(string)<br>    region     = optional(string)<br>    token      = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Display name of the rancher2\_cloud\_credential | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloud_cred"></a> [cloud\_cred](#output\_cloud\_cred) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
