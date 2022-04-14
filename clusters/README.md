This terraform is for creating the downstream clusters to test Ranchers scaling ability

First, run `terraform init` to get plugins downloaded

Then, create a `terraform.tfvars` file.

This `terraform.tfvars` is the optimal config to max out the host with maximum number of clusters that be ran in it. See `variables.tf` for more options.
Sometimes a cluster won't provision so in a large run there may be some clusters that never provision. That is fine and expected as the hosts are packed with k3s clusters.

```
rancher_api_url           = "https://rancher-server.go"
rancher_token_key         = ""
cluster_count             = 15
server_instance_type      = "m5.xlarge"
k3d_version               = "v4.4.5"
install_k3s_image         = "v1.21.1-k3s1"
```

The total number of clusters will be `N` * `cluster_count` from the `terraform.tfvars` file

To run call `provision_clusters.sh N` where `N` is the number of hosts required. AWS credentials will be required so they can either be set in the env or on the command line when calling the script

To cleanup, there is a `destroy_clusters.sh` however this will also delete all the clusters from Rancher and with the cluster GC being slow this can take a long time (hours) on a large setup. The faster way, assuming the control plane is coming down as well, is to just delete the hosts from AWS and tear down the control plane.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.22.0 |
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | 1.24.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.k3s-server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [rancher2_cluster.k3s](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"us-west-1"` | no |
| <a name="input_cluster_count"></a> [cluster\_count](#input\_cluster\_count) | Number of clusters to provision | `number` | n/a | yes |
| <a name="input_cluster_labels"></a> [cluster\_labels](#input\_cluster\_labels) | Labels to add to each provisioned cluster | `map(any)` | `{}` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Unique identifier used in resource names and tags | `string` | `"load-testing"` | no |
| <a name="input_insecure_flag"></a> [insecure\_flag](#input\_insecure\_flag) | Flag used to determine if Rancher is using self-signed invalid certs (using a private CA) | `bool` | `false` | no |
| <a name="input_install_k3s_image"></a> [install\_k3s\_image](#input\_install\_k3s\_image) | k3s image to use during install (container image tag with the 'v') | `string` | `"v1.19.3-k3s1"` | no |
| <a name="input_k3d_version"></a> [k3d\_version](#input\_k3d\_version) | k3d version to use during cluster create (release tag with the 'v') | `string` | `"v3.4.0"` | no |
| <a name="input_k3s_cluster_secret"></a> [k3s\_cluster\_secret](#input\_k3s\_cluster\_secret) | k3s cluster secret | `string` | `""` | no |
| <a name="input_k3s_server_args"></a> [k3s\_server\_args](#input\_k3s\_server\_args) | extra args to pass to k3s server | `string` | `""` | no |
| <a name="input_rancher_api_url"></a> [rancher\_api\_url](#input\_rancher\_api\_url) | api url for rancher server | `string` | n/a | yes |
| <a name="input_rancher_token_key"></a> [rancher\_token\_key](#input\_rancher\_token\_key) | rancher server API token | `string` | n/a | yes |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | A list of security group names (EC2-Classic) or IDs (default VPC) to associate with | `list(any)` | `[]` | no |
| <a name="input_server_instance_type"></a> [server\_instance\_type](#input\_server\_instance\_type) | Instance type to use for k3s server | `string` | n/a | yes |
| <a name="input_ssh_keys"></a> [ssh\_keys](#input\_ssh\_keys) | SSH keys to inject into the EC2 instances | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_registration_tokens"></a> [cluster\_registration\_tokens](#output\_cluster\_registration\_tokens) | The k3s cluster registration token |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
