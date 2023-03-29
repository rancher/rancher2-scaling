# install-common

This component module can be used to install cert-manager and/or Rancher.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.rancher](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [null_resource.wait_for_cert_manager](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.wait_for_rancher](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [rancher2_bootstrap.admin](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/bootstrap) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_byo_certs_bucket_path"></a> [byo\_certs\_bucket\_path](#input\_byo\_certs\_bucket\_path) | Optional: String that defines the path on the S3 Bucket where your certs are stored. NOTE: assumes certs are stored in a tarball within a folder below the top-level bucket e.g.: my-bucket/certificates/my\_certs.tar.gz. Certs should be stored within a single folder, certs nested in sub-folders will not be handled | `string` | `""` | no |
| <a name="input_cattle_prometheus_metrics"></a> [cattle\_prometheus\_metrics](#input\_cattle\_prometheus\_metrics) | Boolean variable that defines whether or not to enable the CATTLE\_PROMETHEUS\_METRICS env var for Rancher | `bool` | `true` | no |
| <a name="input_certmanager_version"></a> [certmanager\_version](#input\_certmanager\_version) | Version of cert-manager to install | `string` | `"1.8.1"` | no |
| <a name="input_cluster_host_url"></a> [cluster\_host\_url](#input\_cluster\_host\_url) | K8s cluster api server url | `string` | `null` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | `null` | no |
| <a name="input_helm_rancher_chart_values_path"></a> [helm\_rancher\_chart\_values\_path](#input\_helm\_rancher\_chart\_values\_path) | Local path to the templated values.yaml to be used for the Rancher Server Helm install | `string` | `null` | no |
| <a name="input_helm_rancher_repo"></a> [helm\_rancher\_repo](#input\_helm\_rancher\_repo) | The repo URL to use for Rancher Server charts | `string` | `"https://releases.rancher.com/server-charts/latest"` | no |
| <a name="input_ingress_class"></a> [ingress\_class](#input\_ingress\_class) | Which Rancher-supported ingress to use | `string` | `"nginx"` | no |
| <a name="input_install_certmanager"></a> [install\_certmanager](#input\_install\_certmanager) | Boolean that defines whether or not to install Cert-Manager | `bool` | `true` | no |
| <a name="input_install_rancher"></a> [install\_rancher](#input\_install\_rancher) | Boolean that defines whether or not to install Rancher | `bool` | `true` | no |
| <a name="input_kube_config_path"></a> [kube\_config\_path](#input\_kube\_config\_path) | Path to kubeconfig file on local machine | `string` | `null` | no |
| <a name="input_letsencrypt_email"></a> [letsencrypt\_email](#input\_letsencrypt\_email) | LetsEncrypt email address to use | `string` | `null` | no |
| <a name="input_private_ca_file"></a> [private\_ca\_file](#input\_private\_ca\_file) | Optional: String that defines the name of the private CA .pem file in the specified S3 bucket's cert tarball | `string` | `""` | no |
| <a name="input_rancher_env_vars"></a> [rancher\_env\_vars](#input\_rancher\_env\_vars) | A list of maps representing Rancher environment variables | `list(map(string))` | `[]` | no |
| <a name="input_rancher_image"></a> [rancher\_image](#input\_rancher\_image) | n/a | `string` | `"rancher/rancher"` | no |
| <a name="input_rancher_image_tag"></a> [rancher\_image\_tag](#input\_rancher\_image\_tag) | Rancher image tag to install, this can differ from rancher\_version which is the chart being used to install Rancher | `string` | `null` | no |
| <a name="input_rancher_node_count"></a> [rancher\_node\_count](#input\_rancher\_node\_count) | n/a | `number` | `1` | no |
| <a name="input_rancher_password"></a> [rancher\_password](#input\_rancher\_password) | Password to set for admin user during bootstrap of Rancher Server, if not set random password will be generated | `string` | `""` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | Version of Rancher to install - Do not include the v prefix. | `string` | n/a | yes |
| <a name="input_s3_bucket_region"></a> [s3\_bucket\_region](#input\_s3\_bucket\_region) | Optional: String that defines the AWS region of the S3 Bucket that stores the desired certs. Required if 'byo\_certs\_bucket\_path' is set. Defaults to the aws\_region if not set | `string` | `""` | no |
| <a name="input_subdomain"></a> [subdomain](#input\_subdomain) | subdomain to host rancher on | `string` | `null` | no |
| <a name="input_tls_cert_file"></a> [tls\_cert\_file](#input\_tls\_cert\_file) | Optional: String that defines the name of the TLS Certificate file in the specified S3 bucket's cert tarball. Required if 'byo\_certs\_bucket\_path' is set | `string` | `""` | no |
| <a name="input_tls_key_file"></a> [tls\_key\_file](#input\_tls\_key\_file) | Optional: String that defines the name of the TLS Key file in the specified S3 bucket's cert tarball. Required if 'byo\_certs\_bucket\_path' is set | `string` | `""` | no |
| <a name="input_use_new_bootstrap"></a> [use\_new\_bootstrap](#input\_use\_new\_bootstrap) | Boolean that defines whether or not utilize the new bootstrap password process used in 2.6.x | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rancher_token"></a> [rancher\_token](#output\_rancher\_token) | n/a |
| <a name="output_rancher_url"></a> [rancher\_url](#output\_rancher\_url) | n/a |
| <a name="output_use_new_bootstrap"></a> [use\_new\_bootstrap](#output\_use\_new\_bootstrap) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
