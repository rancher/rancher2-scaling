# deploy-chart

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.9.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.local_chart](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.remote_chart](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kube_config_path"></a> [kube\_config\_path](#input\_kube\_config\_path) | Path to kubeconfig file on local machine | `string` | `null` | no |
| <a name="input_local_chart_path"></a> [local\_chart\_path](#input\_local\_chart\_path) | n/a | `any` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | n/a | `any` | n/a | yes |
| <a name="input_num_charts"></a> [num\_charts](#input\_num\_charts) | n/a | `number` | `1` | no |
| <a name="input_release_prefix"></a> [release\_prefix](#input\_release\_prefix) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_metadata"></a> [metadata](#output\_metadata) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
