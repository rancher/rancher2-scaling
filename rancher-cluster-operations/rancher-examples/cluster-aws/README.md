# cluster-aws

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.18.0 |
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | 1.24.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.3.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_cloud_credential"></a> [aws\_cloud\_credential](#module\_aws\_cloud\_credential) | ../../rancher-cloud-credential | n/a |
| <a name="module_aws_cluster_v1"></a> [aws\_cluster\_v1](#module\_aws\_cluster\_v1) | ../../rancher-cluster/v1 | n/a |
| <a name="module_aws_node_template"></a> [aws\_node\_template](#module\_aws\_node\_template) | ../../rancher-node-template | n/a |
| <a name="module_secret"></a> [secret](#module\_secret) | ../../rancher-secret | n/a |

## Resources

| Name | Type |
|------|------|
| [rancher2_cluster_sync.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster_sync) | resource |
| [rancher2_node_pool.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/node_pool) | resource |
| [random_id.index](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zone.selected_az](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zone) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_subnets.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | n/a | `string` | n/a | yes |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | n/a | `string` | n/a | yes |
| <a name="input_image"></a> [image](#input\_image) | Cloud provider-specific image name string. | `string` | `"ubuntu-minimal/images/*/ubuntu-bionic-18.04-*"` | no |
| <a name="input_insecure_flag"></a> [insecure\_flag](#input\_insecure\_flag) | Flag used to determine if Rancher is using self-signed invalid certs (using a private CA) | `bool` | `false` | no |
| <a name="input_k8s_distribution"></a> [k8s\_distribution](#input\_k8s\_distribution) | The K8s distribution to use for setting up the cluster. One of k3s, rke1, or rke2. | `string` | `"rke1"` | no |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | Version of k8s to use for downstream cluster (should match to a valid var.k8s\_distribution-specific version). Defaults to a valid RKE1 version | `string` | `"v1.20.15-rancher1-4"` | no |
| <a name="input_node_instance_type"></a> [node\_instance\_type](#input\_node\_instance\_type) | Cloud provider-specific instance type string to use for the nodes | `string` | `"t3a.large"` | no |
| <a name="input_rancher_api_url"></a> [rancher\_api\_url](#input\_rancher\_api\_url) | api url for rancher server | `string` | n/a | yes |
| <a name="input_rancher_token_key"></a> [rancher\_token\_key](#input\_rancher\_token\_key) | rancher server API token | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Cloud provider-specific region string. Defaults to a Linode and AWS-compatible region. | `string` | `"us-west-1"` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | A list of security group names (EC2-Classic) or IDs (default VPC) to associate with | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
