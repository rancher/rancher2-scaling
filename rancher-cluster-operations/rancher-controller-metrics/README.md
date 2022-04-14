# rancher-controller-metrics

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_config_map.rancher_controllers](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_manifest.rancher_service_monitor](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_secret.bearer_token_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_rancher_token"></a> [rancher\_token](#input\_rancher\_token) | Rancher2 API token for authentication | `string` | `null` | no |
| <a name="input_rancher_token_id"></a> [rancher\_token\_id](#input\_rancher\_token\_id) | Rancher2 API token's ID for authentication | `string` | `null` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | The Rancher Server's version | `string` | `"null"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
