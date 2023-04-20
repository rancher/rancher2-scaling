# cluster-linode

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | 1.24.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.3.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_linode_cloud_credential"></a> [linode\_cloud\_credential](#module\_linode\_cloud\_credential) | ../../rancher-cloud-credential | n/a |
| <a name="module_linode_cluster_v1"></a> [linode\_cluster\_v1](#module\_linode\_cluster\_v1) | ../../rancher-cluster/v1 | n/a |
| <a name="module_linode_node_template"></a> [linode\_node\_template](#module\_linode\_node\_template) | ../../rancher-node-template | n/a |
| <a name="module_secret"></a> [secret](#module\_secret) | ../../rancher-secret | n/a |

## Resources

| Name | Type |
|------|------|
| [rancher2_cluster_sync.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster_sync) | resource |
| [rancher2_node_pool.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/node_pool) | resource |
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_image"></a> [image](#input\_image) | Cloud provider-specific image name string. | `string` | `"linode/ubuntu18.04"` | no |
| <a name="input_insecure_flag"></a> [insecure\_flag](#input\_insecure\_flag) | Flag used to determine if Rancher is using self-signed invalid certs (using a private CA) | `bool` | `false` | no |
| <a name="input_k8s_distribution"></a> [k8s\_distribution](#input\_k8s\_distribution) | The K8s distribution to use for setting up the cluster. One of k3s, rke1, or rke2. | `string` | `"rke1"` | no |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | Version of k8s to use for downstream cluster (should match to a valid var.k8s\_distribution-specific version). Defaults to a valid RKE1 version | `string` | `"v1.20.15-rancher1-4"` | no |
| <a name="input_linode_token"></a> [linode\_token](#input\_linode\_token) | n/a | `string` | `null` | no |
| <a name="input_node_instance_type"></a> [node\_instance\_type](#input\_node\_instance\_type) | Cloud provider-specific instance type string to use for the nodes | `string` | `"g6-standard-2"` | no |
| <a name="input_rancher_api_url"></a> [rancher\_api\_url](#input\_rancher\_api\_url) | api url for rancher server | `string` | n/a | yes |
| <a name="input_rancher_token_key"></a> [rancher\_token\_key](#input\_rancher\_token\_key) | rancher server API token | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Cloud provider-specific region string. Defaults to a Linode-compatible region. | `string` | `"us-west"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
