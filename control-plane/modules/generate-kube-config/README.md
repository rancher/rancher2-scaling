# generate-kube-config

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_file.kubeconfig](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_identifier_prefix"></a> [identifier\_prefix](#input\_identifier\_prefix) | n/a | `any` | n/a | yes |
| <a name="input_kubeconfig_content"></a> [kubeconfig\_content](#input\_kubeconfig\_content) | n/a | `any` | n/a | yes |
| <a name="input_kubeconfig_dir"></a> [kubeconfig\_dir](#input\_kubeconfig\_dir) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubeconfig_path"></a> [kubeconfig\_path](#output\_kubeconfig\_path) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
