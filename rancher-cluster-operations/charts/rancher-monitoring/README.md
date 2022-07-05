# rancher-monitoring

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [rancher2_app.rancher_monitoring](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/app) | resource |
| [rancher2_app_v2.rancher_monitoring](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/app_v2) | resource |
| [rancher2_catalog.charts_custom](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/catalog) | resource |
| [rancher2_catalog_v2.charts_custom](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/catalog_v2) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Version of rancher-monitoring chart to install | `string` | `null` | no |
| <a name="input_charts_branch"></a> [charts\_branch](#input\_charts\_branch) | The github branch for the desired Rancher chart version | `string` | `"release-v2.6"` | no |
| <a name="input_charts_repo"></a> [charts\_repo](#input\_charts\_repo) | Url to repo hosting charts | `string` | `"https://git.rancher.io/charts"` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | (optional) describe your variable | `string` | `"local"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `string` | n/a | yes |
| <a name="input_rancher_token"></a> [rancher\_token](#input\_rancher\_token) | Rancher2 API token for authentication | `string` | `null` | no |
| <a name="input_rancher_url"></a> [rancher\_url](#input\_rancher\_url) | The Rancher Server's URL | `string` | `null` | no |
| <a name="input_use_v2"></a> [use\_v2](#input\_use\_v2) | Boolean to determine which version of rancher\_catalog and rancher\_app to use | `bool` | `true` | no |
| <a name="input_values"></a> [values](#input\_values) | Values file content for rancher-monitoring | `string` | `null` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
