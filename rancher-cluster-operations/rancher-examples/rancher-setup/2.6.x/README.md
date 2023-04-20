# 2.6.x

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_rancher2.admin"></a> [rancher2.admin](#provider\_rancher2.admin) | 1.24.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_install_common"></a> [install\_common](#module\_install\_common) | ../../../install-common | n/a |
| <a name="module_rancher_monitoring"></a> [rancher\_monitoring](#module\_rancher\_monitoring) | ../../../charts/rancher-monitoring | n/a |
| <a name="module_secret_v2"></a> [secret\_v2](#module\_secret\_v2) | ../../../rancher-secret | n/a |

## Resources

| Name | Type |
|------|------|
| [rancher2_cluster.local](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/data-sources/cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kube_config_path"></a> [kube\_config\_path](#input\_kube\_config\_path) | Path to kubeconfig file on local machine | `string` | `null` | no |
| <a name="input_letsencrypt_email"></a> [letsencrypt\_email](#input\_letsencrypt\_email) | LetsEncrypt email address to use | `string` | `null` | no |
| <a name="input_rancher_api_url"></a> [rancher\_api\_url](#input\_rancher\_api\_url) | API url for Rancher server | `string` | n/a | yes |
| <a name="input_rancher_node_count"></a> [rancher\_node\_count](#input\_rancher\_node\_count) | n/a | `number` | `null` | no |
| <a name="input_rancher_password"></a> [rancher\_password](#input\_rancher\_password) | Password to set for admin user during bootstrap of Rancher Server, if not set random password will be generated | `string` | `""` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | The version of Rancher to install (must be a 2.6.x version) | `string` | `"2.6.5"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
