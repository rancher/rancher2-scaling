# rancher-secret

This component module can be used to create or retrieve `rancher2_secret` or `rancher2_secret_v2` resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | 1.23.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [rancher2_secret_v2.foo](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/secret_v2) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | ID of the cluster where the Secrets should be created | `string` | `"local"` | no |
| <a name="input_data"></a> [data](#input\_data) | Map of data to include in each secret | `map(any)` | <pre>{<br>  "deleteme": "True"<br>}</pre> | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | (optional) Name prefix for each secret | `string` | `"tf-secret"` | no |
| <a name="input_secrets_per_workspace"></a> [secrets\_per\_workspace](#input\_secrets\_per\_workspace) | The # of Secrets to create per terraform workspace | `number` | `1` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
