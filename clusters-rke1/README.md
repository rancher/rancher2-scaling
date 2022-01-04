This terraform is for creating the downstream RKE clusters to test Ranchers scaling ability

First, run `terraform init` to get plugins downloaded

Then, create a `terraform.tfvars` file.

This is an example `terraform.tfvars`. See `variables.tf` for more options.

```
rancher_api_url        = "<rancher server url>"
rancher_token_key      = "<rancher token>"
server_instance_type   = "m5.xlarge"
aws_region             = "us-west-1"
aws_access_key         = "<aws access key>"
aws_secret_key         = "<aws secret key>"
security_groups        = ["my-sec-group1", "my-sec-group2"]
insecure_flag          = false
iam_instance_profile   = "MyIAMInstanceProfile"
install_docker_version = "20.10"
```

The total number of nodes will be `N` * `nodes_per_pool` * `node_pool_count` from the `terraform.tfvars` file.

To run call `provision_clusters.sh N` where `N` is the number of clusters required. AWS credentials will be required so they can either be set in the `terraform.tfvars` file, in the env, or on the command line when calling the script.

To cleanup, there is a `destroy_clusters.sh`, this script will perform a `terraform destroy` operation in reverse-order on each workspace created by the provisioning script. However this will also delete all the clusters from Rancher and with the cluster GC being slow this can take a long time (hours) on a large setup. The faster way, assuming the control plane is coming down as well, is to just delete the hosts from AWS and tear down the control plane. Alternatively, manually deleting the clusters via the UI is somewhat faster. You may need to verify the nodes were deleted properly as it is possible for nodes to become de-synced and replaced by Rancher without being shut down.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.70.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.0 |
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | 1.22.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_shared_node_template"></a> [shared\_node\_template](#module\_shared\_node\_template) | ./modules/node-template | n/a |

## Resources

| Name | Type |
|------|------|
| [null_resource.determine_nt](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [rancher2_cluster.rke1](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster) | resource |
| [rancher2_node_pool.aws_np](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/node_pool) | resource |
| [random_id.index](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zone.selected_az](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zone) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_iam_instance_profile.rancher_iam_full_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_instance_profile) | data source |
| [aws_subnet_ids.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [rancher2_node_template.existing_nt](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/data-sources/node_template) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | n/a | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"us-west-1"` | no |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | n/a | `string` | `null` | no |
| <a name="input_cluster_labels"></a> [cluster\_labels](#input\_cluster\_labels) | Labels to add to each provisioned cluster | `map(any)` | `{}` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Unique identifier appended to the Rancher url subdomain | `string` | `"load-testing"` | no |
| <a name="input_create_node_reqs"></a> [create\_node\_reqs](#input\_create\_node\_reqs) | Flag defining if a cloud credential & node template should be created on tf apply. Useful for scripting purposes | `bool` | `true` | no |
| <a name="input_existing_node_template"></a> [existing\_node\_template](#input\_existing\_node\_template) | (Optional) Name of an existing node template to use. Only use this if create\_node\_reqs is false. | `string` | `null` | no |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | n/a | `string` | `null` | no |
| <a name="input_insecure_flag"></a> [insecure\_flag](#input\_insecure\_flag) | Flag used to determine if Rancher is using self-signed invalid certs (using a private CA) | `bool` | `false` | no |
| <a name="input_install_docker_version"></a> [install\_docker\_version](#input\_install\_docker\_version) | The version of docker to install. Available docker versions can be found at: https://github.com/rancher/install-docker | `string` | `"20.10"` | no |
| <a name="input_node_pool_count"></a> [node\_pool\_count](#input\_node\_pool\_count) | Number of node pools to create | `number` | `3` | no |
| <a name="input_nodes_per_pool"></a> [nodes\_per\_pool](#input\_nodes\_per\_pool) | Number of nodes to create per node pool | `number` | `1` | no |
| <a name="input_rancher_api_url"></a> [rancher\_api\_url](#input\_rancher\_api\_url) | api url for rancher server | `string` | n/a | yes |
| <a name="input_rancher_token_key"></a> [rancher\_token\_key](#input\_rancher\_token\_key) | rancher server API token | `string` | n/a | yes |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | A list of security group names (EC2-Classic) or IDs (default VPC) to associate with | `list(any)` | `[]` | no |
| <a name="input_server_instance_type"></a> [server\_instance\_type](#input\_server\_instance\_type) | Instance type to use for rke1 server | `string` | n/a | yes |
| <a name="input_ssh_keys"></a> [ssh\_keys](#input\_ssh\_keys) | SSH keys to inject into the EC2 instances | `list(any)` | `[]` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | Size of the storage volume to use in GB | `string` | `"32"` | no |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | Type of storage volume to use | `string` | `"gp2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_create_node_reqs"></a> [create\_node\_reqs](#output\_create\_node\_reqs) | n/a |
| <a name="output_node_template"></a> [node\_template](#output\_node\_template) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
