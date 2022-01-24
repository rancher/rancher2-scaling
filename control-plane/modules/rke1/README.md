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
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `any` | n/a | yes |
| <a name="input_install_docker_version"></a> [install\_docker\_version](#input\_install\_docker\_version) | Version of Docker to install | `string` | `"20.10"` | no |
| <a name="input_install_k8s_version"></a> [install\_k8s\_version](#input\_install\_k8s\_version) | Version of K8s to install | `string` | n/a | yes |
| <a name="input_nodes_ids"></a> [nodes\_ids](#input\_nodes\_ids) | Node IDs of the desired nodes for the RKE HA setup | `list(string)` | n/a | yes |
| <a name="input_nodes_private_ips"></a> [nodes\_private\_ips](#input\_nodes\_private\_ips) | Private IP addresses of the desired nodes for the RKE HA setup | `list(string)` | n/a | yes |
| <a name="input_nodes_public_ips"></a> [nodes\_public\_ips](#input\_nodes\_public\_ips) | Public IP addresses of the desired nodes for the RKE HA setup | `list(string)` | n/a | yes |
| <a name="input_s3_instance_profile"></a> [s3\_instance\_profile](#input\_s3\_instance\_profile) | Optional: String that defines the name of the IAM Instance Profile that grants S3 access to the EC2 instances. Required if 'byo\_certs\_bucket\_path' is set | `string` | `""` | no |
| <a name="input_server_node_count"></a> [server\_node\_count](#input\_server\_node\_count) | n/a | `any` | n/a | yes |
| <a name="input_ssh_key_path"></a> [ssh\_key\_path](#input\_ssh\_key\_path) | Path to the ssh\_key file to be used for connecting to the nodes | `string` | `null` | no |

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
