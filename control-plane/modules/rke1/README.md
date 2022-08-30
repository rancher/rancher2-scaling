# rke1

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_rke"></a> [rke](#provider\_rke) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [rke_cluster.local](https://registry.terraform.io/providers/rancher/rke/latest/docs/resources/cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_provider_config"></a> [cloud\_provider\_config](#input\_cloud\_provider\_config) | A map containing the values for a custom cloud provider configuration. https://registry.terraform.io/providers/rancher/rke/latest/docs/resources/cluster#cloud_provider | `map(any)` | `null` | no |
| <a name="input_cloud_provider_name"></a> [cloud\_provider\_name](#input\_cloud\_provider\_name) | A string designating the desired cloud provider's name. https://registry.terraform.io/providers/rancher/rke/latest/docs/resources/cluster#name | `string` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster | `string` | `"local"` | no |
| <a name="input_dedicated_monitoring_node"></a> [dedicated\_monitoring\_node](#input\_dedicated\_monitoring\_node) | Boolean that determines whether or not one of the given nodes will be taintend and labelled as a dedicated monitoring node. | `bool` | `false` | no |
| <a name="input_hostname_override_prefix"></a> [hostname\_override\_prefix](#input\_hostname\_override\_prefix) | String to prepend to the hostname\_override field for each node. (Ignored for AWS cloud provider) | `string` | `""` | no |
| <a name="input_install_k8s_version"></a> [install\_k8s\_version](#input\_install\_k8s\_version) | Version of K8s to install | `string` | `""` | no |
| <a name="input_nodes_ids"></a> [nodes\_ids](#input\_nodes\_ids) | Node IDs of the desired nodes for the RKE HA setup | `list(string)` | n/a | yes |
| <a name="input_nodes_private_ips"></a> [nodes\_private\_ips](#input\_nodes\_private\_ips) | Private IP addresses of the desired nodes for the RKE HA setup | `list(string)` | n/a | yes |
| <a name="input_nodes_public_ips"></a> [nodes\_public\_ips](#input\_nodes\_public\_ips) | Public IP addresses of the desired nodes for the RKE HA setup | `list(string)` | n/a | yes |
| <a name="input_s3_instance_profile"></a> [s3\_instance\_profile](#input\_s3\_instance\_profile) | Optional: String that defines the name of the IAM Instance Profile that grants S3 access to the EC2 instances. Required if 'byo\_certs\_bucket\_path' is set | `string` | `""` | no |
| <a name="input_secrets_encryption"></a> [secrets\_encryption](#input\_secrets\_encryption) | (Optional) Boolean that determines if secrets-encryption should be enabled for rke2 | `bool` | `false` | no |
| <a name="input_ssh_key_path"></a> [ssh\_key\_path](#input\_ssh\_key\_path) | Path to the ssh\_key file to be used for connecting to the nodes | `string` | `null` | no |
| <a name="input_user"></a> [user](#input\_user) | Name of the user to SSH as | `string` | `"ubuntu"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_server_url"></a> [api\_server\_url](#output\_api\_server\_url) | n/a |
| <a name="output_ca_crt"></a> [ca\_crt](#output\_ca\_crt) | n/a |
| <a name="output_client_cert"></a> [client\_cert](#output\_client\_cert) | n/a |
| <a name="output_client_key"></a> [client\_key](#output\_client\_key) | n/a |
| <a name="output_cluster_yaml"></a> [cluster\_yaml](#output\_cluster\_yaml) | n/a |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | n/a |
| <a name="output_rke_cluster"></a> [rke\_cluster](#output\_rke\_cluster) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
