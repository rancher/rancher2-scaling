# rancher-controller-metrics

This module should only be applied against Rancher clusters on version `2.5.x` with `rancher-monitoring` installed and the `CATTLE_PROMETHEUS_METRICS` environment variable set to true.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.14.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_config_map.rancher_controllers](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kube_config_path"></a> [kube\_config\_path](#input\_kube\_config\_path) | Path to kubeconfig file on local machine | `string` | `null` | no |
| <a name="input_rancher_token"></a> [rancher\_token](#input\_rancher\_token) | Rancher2 API token for authentication | `string` | `null` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | The Rancher Server's version | `string` | `"null"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
