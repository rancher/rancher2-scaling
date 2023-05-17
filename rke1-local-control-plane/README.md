## Control plane usage:
### Download and Install the Required RKE1 version
RKE binary releases can be found at: https://github.com/rancher/rke/releases.
  1. Download the appropriate binary
  2. Give it executable permissions `chmod +x <your binary>`
  3. Rename it to `rke`
  4. Move it into your `PATH` so that it can be run in a shell terminal

### Create AWS profile
Create an AWS profile named `rancher-eng` and provide access keys
```bash
aws configure --profile rancher-eng
```

### Creating cluster resources
Initialize terraform default workspace. This only needs to be run once to create the initial workspace environment:
```bash
cd control-plane
terraform init
```
Update modules mentioned in root module from their respective source:
```
terraform get --update
terraform init
```

AWS credentials are required so they can either be set in the env or on the command line before running the below commands

Create k3s cluster with **mariadb** data store:

```bash
terraform apply
```
Creating the cluster resources takes about 10-15 minutes. After successfully running `apply` terraform will output information needed to connect to the rancher server.

### Destroying cluster resources

```bash
terraform destroy
```

Destroying cluster resources takes about 10-15 minutes.

### Configuration:
Configuration changes should be done in `terraform.tfvars` to override default variable settings in `variables.tf`. The format of the `terraform.tfvars` file must be in done with key/value pairs.

#### Example terraform.tfvars file:
```
ssh_keys = [<ssh keys to place on nodes>
]
ssh_key_path = "<private ssh keypath for connecting to nodes>"

### General Settings ###
region             = "us-west-1"
domain                 = "qa.rancher.space"
random_prefix          = "test"

### Rancher ###
rancher_chart         = "latest"
node_count    = 3
node_type = "m5.xlarge"
rancher_password      = "<your rancher pass>"
rancher_charts_branch = "dev-v2.6"
rancher_image_tag     = "v2.6.7"
rancher_version       = "2.6.7"

### Monitoring ###
monitoring_version               = "100.1.3+up19.0.3"
install_monitoring               = true
cattle_prometheus_metrics        = true
monitoring_crd_chart_values_path = "./files/values/rancher_monitoring_crd_chart_values.yaml"
monitoring_chart_values_path     = "./files/values/rancher_monitoring_chart_values.yaml"

#### Misc Settings ####
enable_secrets_encryption = false
sensitive_token           = false

### RKE1 ###
k8s_distribution       = "rke1"
install_k8s_version    = "v1.24.2-rancher1-1"
install_docker_version = "20.10"

### Certificates ###
letsencrypt_email   = "<your email>"
certmanager_version = "1.8.1"
s3_instance_profile = "RancherK8SUnrestrictedCloudProviderRoleWithRoute53S3FullUS"

```

### Accessing Monitoring
When doing load testing, it is highly likely that the hosts Rancher is running on will die, so attempting to proxy through Rancher to view Grafana is not possible. Monitoring runs on its own node so it wont go down when Rancher or its hosts do. Using `kubectl` Grafana (and anything monitoring related) will still be accessible:
```bash
kubectl port-forward -n cattle-monitoring-system deployment/rancher-monitoring-grafana 8443:3000
```
Then go to `http://127.0.0.1:8443` in a browser to connect back to the Grafana UI.
The port `8443` can be adjusted as need for your local system.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.55.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.3.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.1 |
| <a name="provider_rancher2.admin"></a> [rancher2.admin](#provider\_rancher2.admin) | 1.25.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_infra"></a> [aws\_infra](#module\_aws\_infra) | ../control-plane/modules/aws-infra | n/a |
| <a name="module_install_common"></a> [install\_common](#module\_install\_common) | ../rancher-cluster-operations/install-common | n/a |
| <a name="module_linode_infra"></a> [linode\_infra](#module\_linode\_infra) | ../linode-infra | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.linode](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [local_file.cluster_yml](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.rke](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.set_loglevel](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [rancher2_app_v2.rancher_monitoring](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/app_v2) | resource |
| [rancher2_catalog_v2.rancher_charts_custom](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/catalog_v2) | resource |
| [rancher2_setting.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/setting) | resource |
| [random_password.rancher_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_pet.identifier](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_route53_zone.linode](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [local_file.kube_config](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [rancher2_setting.this](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/data-sources/setting) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_byo_certs_bucket_path"></a> [byo\_certs\_bucket\_path](#input\_byo\_certs\_bucket\_path) | Optional: String that defines the path on the S3 Bucket where your certs are stored. NOTE: assumes certs are stored in a tarball within a folder below the top-level bucket e.g.: my-bucket/certificates/my\_certs.tar.gz. Certs should be stored within a single folder, certs nested in sub-folders will not be handled | `string` | `""` | no |
| <a name="input_cattle_prometheus_metrics"></a> [cattle\_prometheus\_metrics](#input\_cattle\_prometheus\_metrics) | Boolean variable that defines whether or not to enable the CATTLE\_PROMETHEUS\_METRICS env var for Rancher | `bool` | `true` | no |
| <a name="input_certmanager_version"></a> [certmanager\_version](#input\_certmanager\_version) | Version of cert-manager to install | `string` | `"1.8.1"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | `""` | no |
| <a name="input_enable_audit_log"></a> [enable\_audit\_log](#input\_enable\_audit\_log) | (Optional) Boolean that determines if secrets-encryption should be enabled | `bool` | `false` | no |
| <a name="input_enable_cri_dockerd"></a> [enable\_cri\_dockerd](#input\_enable\_cri\_dockerd) | (Optional) Boolean that determines if CRI dockerd is enabled for the kubelet (required for k8s >= v1.24.x) | `bool` | `true` | no |
| <a name="input_enable_secrets_encryption"></a> [enable\_secrets\_encryption](#input\_enable\_secrets\_encryption) | (Optional) Boolean that determines if secrets-encryption should be enabled | `bool` | `false` | no |
| <a name="input_infra_provider"></a> [infra\_provider](#input\_infra\_provider) | (optional) describe your variable | `string` | n/a | yes |
| <a name="input_install_certmanager"></a> [install\_certmanager](#input\_install\_certmanager) | Boolean that defines whether or not to install Cert-Manager | `bool` | `true` | no |
| <a name="input_install_docker_version"></a> [install\_docker\_version](#input\_install\_docker\_version) | Version of Docker to install | `string` | `"20.10"` | no |
| <a name="input_install_k8s_version"></a> [install\_k8s\_version](#input\_install\_k8s\_version) | Version of K8s to install | `string` | `""` | no |
| <a name="input_install_monitoring"></a> [install\_monitoring](#input\_install\_monitoring) | Boolean that defines whether or not to install rancher-monitoring | `bool` | `true` | no |
| <a name="input_install_rancher"></a> [install\_rancher](#input\_install\_rancher) | Boolean that defines whether or not to install Rancher | `bool` | `true` | no |
| <a name="input_letsencrypt_email"></a> [letsencrypt\_email](#input\_letsencrypt\_email) | LetsEncrypt email address to use | `string` | `"none@none.com"` | no |
| <a name="input_linode_token"></a> [linode\_token](#input\_linode\_token) | Linode API token | `string` | n/a | yes |
| <a name="input_linode_users"></a> [linode\_users](#input\_linode\_users) | List of Linode usernames that are authorized to access the linode(s).<br>If the usernames have associated SSH keys, the keys will be appended to the root user's ~/.ssh/authorized\_keys file automatically.<br>Changing this list forces the creation of new Linode(s). | `list(string)` | `null` | no |
| <a name="input_monitoring_chart_values_path"></a> [monitoring\_chart\_values\_path](#input\_monitoring\_chart\_values\_path) | Path to custom values.yaml for rancher-monitoring | `string` | `null` | no |
| <a name="input_monitoring_crd_chart_values_path"></a> [monitoring\_crd\_chart\_values\_path](#input\_monitoring\_crd\_chart\_values\_path) | Path to custom values.yaml for rancher-monitoring | `string` | `null` | no |
| <a name="input_monitoring_version"></a> [monitoring\_version](#input\_monitoring\_version) | Version of Monitoring v2 to install - Do not include the v prefix. | `string` | `""` | no |
| <a name="input_node_count"></a> [node\_count](#input\_node\_count) | n/a | `number` | `1` | no |
| <a name="input_node_image"></a> [node\_image](#input\_node\_image) | The image ID to use for the selected cloud provider.<br>AWS assumes an AMI ID, Linode assumes a linode image.<br>Defaults to the latest 18.04 Ubuntu image. | `string` | `null` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Cloud provider-specific node/instance type used for the rancher servers | `string` | `null` | no |
| <a name="input_private_ca_file"></a> [private\_ca\_file](#input\_private\_ca\_file) | Optional: String that defines the name of the private CA .pem file in the specified S3 bucket's cert tarball | `string` | `""` | no |
| <a name="input_r53_domain"></a> [r53\_domain](#input\_r53\_domain) | DNS domain for Route53 zone (defaults to domain if unset) | `string` | `""` | no |
| <a name="input_rancher_additional_values"></a> [rancher\_additional\_values](#input\_rancher\_additional\_values) | A list of objects representing values for the Rancher helm chart | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_rancher_chart"></a> [rancher\_chart](#input\_rancher\_chart) | Helm chart to use for Rancher install | `string` | `"stable"` | no |
| <a name="input_rancher_charts_branch"></a> [rancher\_charts\_branch](#input\_rancher\_charts\_branch) | The github branch for the desired Rancher chart version | `string` | `"release-v2.6"` | no |
| <a name="input_rancher_charts_repo"></a> [rancher\_charts\_repo](#input\_rancher\_charts\_repo) | The URL for the desired Rancher charts | `string` | `"https://git.rancher.io/charts"` | no |
| <a name="input_rancher_env_vars"></a> [rancher\_env\_vars](#input\_rancher\_env\_vars) | A list of objects representing Rancher environment variables | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_rancher_image"></a> [rancher\_image](#input\_rancher\_image) | n/a | `string` | `"rancher/rancher"` | no |
| <a name="input_rancher_image_tag"></a> [rancher\_image\_tag](#input\_rancher\_image\_tag) | Rancher image tag to install, this can differ from rancher\_version which is the chart being used to install Rancher | `string` | `"master-head"` | no |
| <a name="input_rancher_loglevel"></a> [rancher\_loglevel](#input\_rancher\_loglevel) | A string specifying the loglevel to set on the rancher pods. One of: info, debug or trace. https://rancher.com/docs/rancher/v2.x/en/troubleshooting/logging/ | `string` | `"info"` | no |
| <a name="input_rancher_password"></a> [rancher\_password](#input\_rancher\_password) | Password to set for admin user during bootstrap of Rancher Server, if not set random password will be generated | `string` | `""` | no |
| <a name="input_rancher_settings"></a> [rancher\_settings](#input\_rancher\_settings) | A list of objects defining modifications to the named rancher settings | <pre>list(object({<br>    name        = string<br>    value       = any<br>    annotations = optional(map(string))<br>    labels      = optional(map(string))<br>  }))</pre> | `[]` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | Version of Rancher to install - Do not include the v prefix. | `string` | n/a | yes |
| <a name="input_random_prefix"></a> [random\_prefix](#input\_random\_prefix) | Prefix to be used with random name generation | `string` | `"rancher"` | no |
| <a name="input_region"></a> [region](#input\_region) | The cloud provider-specific region string | `string` | `"us-west-1"` | no |
| <a name="input_rke_metadata_url"></a> [rke\_metadata\_url](#input\_rke\_metadata\_url) | n/a | `string` | `""` | no |
| <a name="input_s3_bucket_region"></a> [s3\_bucket\_region](#input\_s3\_bucket\_region) | Optional: String that defines the AWS region of the S3 Bucket that stores the desired certs. Required if 'byo\_certs\_bucket\_path' is set. Defaults to the aws\_region if not set | `string` | `""` | no |
| <a name="input_s3_instance_profile"></a> [s3\_instance\_profile](#input\_s3\_instance\_profile) | Optional: String that defines the name of the IAM Instance Profile that grants S3 access to the EC2 instances. Required if 'byo\_certs\_bucket\_path' is set | `string` | `""` | no |
| <a name="input_sensitive_token"></a> [sensitive\_token](#input\_sensitive\_token) | Boolean that determines if the module should treat the generated Rancher Admin API Token as sensitive in the output. | `bool` | `true` | no |
| <a name="input_ssh_key_path"></a> [ssh\_key\_path](#input\_ssh\_key\_path) | Path to the private SSH key file to be used for connecting to the node(s) | `string` | `null` | no |
| <a name="input_ssh_keys"></a> [ssh\_keys](#input\_ssh\_keys) | SSH keys to inject into Rancher instances | `list(any)` | `[]` | no |
| <a name="input_system_images"></a> [system\_images](#input\_system\_images) | A map specifying override values matching the keys at https://github.com/rancher/kontainer-driver-metadata | `map(any)` | `{}` | no |
| <a name="input_tls_cert_file"></a> [tls\_cert\_file](#input\_tls\_cert\_file) | Optional: String that defines the name of the TLS Certificate file in the specified S3 bucket's cert tarball. Required if 'byo\_certs\_bucket\_path' is set | `string` | `""` | no |
| <a name="input_tls_key_file"></a> [tls\_key\_file](#input\_tls\_key\_file) | Optional: String that defines the name of the TLS Key file in the specified S3 bucket's cert tarball. Required if 'byo\_certs\_bucket\_path' is set | `string` | `""` | no |
| <a name="input_user"></a> [user](#input\_user) | Name of the user to SSH as | `string` | `"ubuntu"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cattle_prometheus_metrics"></a> [cattle\_prometheus\_metrics](#output\_cattle\_prometheus\_metrics) | n/a |
| <a name="output_certmanager_version"></a> [certmanager\_version](#output\_certmanager\_version) | n/a |
| <a name="output_install_certmanager"></a> [install\_certmanager](#output\_install\_certmanager) | n/a |
| <a name="output_install_monitoring"></a> [install\_monitoring](#output\_install\_monitoring) | n/a |
| <a name="output_install_rancher"></a> [install\_rancher](#output\_install\_rancher) | n/a |
| <a name="output_kube_config_path"></a> [kube\_config\_path](#output\_kube\_config\_path) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_nodes_ids"></a> [nodes\_ids](#output\_nodes\_ids) | n/a |
| <a name="output_nodes_info"></a> [nodes\_info](#output\_nodes\_info) | n/a |
| <a name="output_nodes_private_ips"></a> [nodes\_private\_ips](#output\_nodes\_private\_ips) | n/a |
| <a name="output_nodes_public_ips"></a> [nodes\_public\_ips](#output\_nodes\_public\_ips) | n/a |
| <a name="output_rancher2_settings"></a> [rancher2\_settings](#output\_rancher2\_settings) | n/a |
| <a name="output_rancher_admin_password"></a> [rancher\_admin\_password](#output\_rancher\_admin\_password) | n/a |
| <a name="output_rancher_charts_branch"></a> [rancher\_charts\_branch](#output\_rancher\_charts\_branch) | n/a |
| <a name="output_rancher_charts_repo"></a> [rancher\_charts\_repo](#output\_rancher\_charts\_repo) | n/a |
| <a name="output_rancher_token"></a> [rancher\_token](#output\_rancher\_token) | n/a |
| <a name="output_rancher_url"></a> [rancher\_url](#output\_rancher\_url) | n/a |
| <a name="output_rancher_version"></a> [rancher\_version](#output\_rancher\_version) | n/a |
| <a name="output_secrets_encryption"></a> [secrets\_encryption](#output\_secrets\_encryption) | n/a |
| <a name="output_use_new_bootstrap"></a> [use\_new\_bootstrap](#output\_use\_new\_bootstrap) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
