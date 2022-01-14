## Control plane usage:
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
ssh_keys                = ["<Your key/s here>"]
db_name                 = "loadthing"
db_subnet_group_name    = "your-subnet-group-name"
db_skip_final_snapshot  = true
rancher_node_count      = 3
rancher_instance_type   = "m5.large"
rancher_password        = "super-secret-and-long-password"
install_k3s_version     = "1.19.3+k3s1"
certmanager_version     = "1.4.2"
random_prefix           = "scale-testing"
server_k3s_exec         = " --write-kubeconfig-mode '0666'"
rancher_image_tag       = "v2.5.1"
rancher_version         = "2.5.1"
monitoring_version      = "9.4.201"
aws_region              = "us-west-1"
domain                  = "your-route53-zone"
letsencrypt_email       = "your@email.com"
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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.71.0 |
| <a name="provider_rancher2.admin"></a> [rancher2.admin](#provider\_rancher2.admin) | 1.22.2 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_infra"></a> [aws\_infra](#module\_aws\_infra) | ./modules/aws-infra | n/a |
| <a name="module_db"></a> [db](#module\_db) | terraform-aws-modules/rds/aws | >= 3.2 |
| <a name="module_generate_kube_config"></a> [generate\_kube\_config](#module\_generate\_kube\_config) | ./modules/generate-kube-config | n/a |
| <a name="module_install_common"></a> [install\_common](#module\_install\_common) | ./modules/install-common | n/a |
| <a name="module_k3s"></a> [k3s](#module\_k3s) | ./modules/aws-k3s | n/a |
| <a name="module_rke1"></a> [rke1](#module\_rke1) | ./modules/rke1 | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.database_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [rancher2_app_v2.rancher_monitoring](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/app_v2) | resource |
| [rancher2_catalog_v2.rancher_charts_custom](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/catalog_v2) | resource |
| [random_password.rancher_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_pet.identifier](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_route53_zone.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnet_ids.all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"us-west-2"` | no |
| <a name="input_byo_certs_bucket_path"></a> [byo\_certs\_bucket\_path](#input\_byo\_certs\_bucket\_path) | Optional: String that defines the path on the S3 Bucket where your certs are stored. NOTE: assumes certs are stored in a tarball within a folder below the top-level bucket e.g.: my-bucket/certificates/my\_certs.tar.gz. Certs should be stored within a single folder, certs nested in sub-folders will not be handled | `string` | `""` | no |
| <a name="input_certmanager_version"></a> [certmanager\_version](#input\_certmanager\_version) | Version of cert-manager to install | `string` | `"1.4.2"` | no |
| <a name="input_db_allocated_storage"></a> [db\_allocated\_storage](#input\_db\_allocated\_storage) | n/a | `number` | `100` | no |
| <a name="input_db_engine"></a> [db\_engine](#input\_db\_engine) | n/a | `string` | `"mariadb"` | no |
| <a name="input_db_engine_version"></a> [db\_engine\_version](#input\_db\_engine\_version) | n/a | `string` | `"10.5"` | no |
| <a name="input_db_instance_class"></a> [db\_instance\_class](#input\_db\_instance\_class) | n/a | `string` | `"db.t3.medium"` | no |
| <a name="input_db_iops"></a> [db\_iops](#input\_db\_iops) | n/a | `number` | `1000` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | n/a | `string` | `"rancher"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Password string for database, must be >= 8 characters. Only printable ASCII characters are allowed, the following are not allowed: '/@" ' | `string` | `"rancher12345"` | no |
| <a name="input_db_port"></a> [db\_port](#input\_db\_port) | n/a | `number` | `3306` | no |
| <a name="input_db_skip_final_snapshot"></a> [db\_skip\_final\_snapshot](#input\_db\_skip\_final\_snapshot) | n/a | `bool` | `true` | no |
| <a name="input_db_storage_encrypted"></a> [db\_storage\_encrypted](#input\_db\_storage\_encrypted) | n/a | `bool` | `false` | no |
| <a name="input_db_storage_type"></a> [db\_storage\_type](#input\_db\_storage\_type) | n/a | `string` | `"io1"` | no |
| <a name="input_db_subnet_group_name"></a> [db\_subnet\_group\_name](#input\_db\_subnet\_group\_name) | Name of DB subnet group. DB instance will be created in the VPC associated with the DB subnet group. If unspecified, will be created in the default VPC | `string` | `null` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | n/a | `string` | `"rancher"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | `""` | no |
| <a name="input_install_certmanager"></a> [install\_certmanager](#input\_install\_certmanager) | Boolean that defines whether or not to install Cert-Manager | `bool` | `true` | no |
| <a name="input_install_docker_version"></a> [install\_docker\_version](#input\_install\_docker\_version) | Version of Docker to install | `string` | `"20.10"` | no |
| <a name="input_install_k3s_version"></a> [install\_k3s\_version](#input\_install\_k3s\_version) | Version of K3S to install (github release tag without the 'v') | `string` | `"1.20.10+k3s1"` | no |
| <a name="input_install_k8s_version"></a> [install\_k8s\_version](#input\_install\_k8s\_version) | Version of K8s to install | `string` | `"1.21.7-rancher1-1"` | no |
| <a name="input_install_monitoring"></a> [install\_monitoring](#input\_install\_monitoring) | Boolean that defines whether or not to install rancher-monitoring | `bool` | `true` | no |
| <a name="input_install_rancher"></a> [install\_rancher](#input\_install\_rancher) | Boolean that defines whether or not to install Rancher | `bool` | `true` | no |
| <a name="input_k8s_distribution"></a> [k8s\_distribution](#input\_k8s\_distribution) | The K8s distribution to use for setting up Rancher (k3s or rke1) | `string` | n/a | yes |
| <a name="input_letsencrypt_email"></a> [letsencrypt\_email](#input\_letsencrypt\_email) | LetsEncrypt email address to use | `string` | `"none@none.com"` | no |
| <a name="input_monitoring_chart_values_path"></a> [monitoring\_chart\_values\_path](#input\_monitoring\_chart\_values\_path) | Path to custom values.yaml for rancher-monitoring | `string` | `null` | no |
| <a name="input_monitoring_version"></a> [monitoring\_version](#input\_monitoring\_version) | Version of Monitoring v2 to install - Do not include the v prefix. | `string` | n/a | yes |
| <a name="input_private_ca_file"></a> [private\_ca\_file](#input\_private\_ca\_file) | Optional: String that defines the name of the private CA .pem file in the specified S3 bucket's cert tarball | `string` | `""` | no |
| <a name="input_r53_domain"></a> [r53\_domain](#input\_r53\_domain) | DNS domain for Route53 zone (defaults to domain if unset) | `string` | `""` | no |
| <a name="input_rancher_chart"></a> [rancher\_chart](#input\_rancher\_chart) | Helm chart to use for Rancher install | `string` | `"stable"` | no |
| <a name="input_rancher_charts_branch"></a> [rancher\_charts\_branch](#input\_rancher\_charts\_branch) | The github branch for the desired Rancher chart version | `string` | `"release-v2.6"` | no |
| <a name="input_rancher_charts_repo"></a> [rancher\_charts\_repo](#input\_rancher\_charts\_repo) | The URL for the desired Rancher charts | `string` | `""` | no |
| <a name="input_rancher_image"></a> [rancher\_image](#input\_rancher\_image) | n/a | `string` | `"rancher/rancher"` | no |
| <a name="input_rancher_image_tag"></a> [rancher\_image\_tag](#input\_rancher\_image\_tag) | Rancher image tag to install, this can differ from rancher\_version which is the chart being used to install Rancher | `string` | `"master-head"` | no |
| <a name="input_rancher_instance_type"></a> [rancher\_instance\_type](#input\_rancher\_instance\_type) | instance type used for the rancher servers | `string` | `"m5.xlarge"` | no |
| <a name="input_rancher_node_count"></a> [rancher\_node\_count](#input\_rancher\_node\_count) | n/a | `number` | `1` | no |
| <a name="input_rancher_password"></a> [rancher\_password](#input\_rancher\_password) | Password to set for admin user during bootstrap of Rancher Server, if not set random password will be generated | `string` | `""` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | Version of Rancher to install - Do not include the v prefix. | `string` | n/a | yes |
| <a name="input_random_prefix"></a> [random\_prefix](#input\_random\_prefix) | Prefix to be used with random name generation | `string` | `"rancher"` | no |
| <a name="input_s3_bucket_region"></a> [s3\_bucket\_region](#input\_s3\_bucket\_region) | Optional: String that defines the AWS region of the S3 Bucket that stores the desired certs. Required if 'byo\_certs\_bucket\_path' is set. Defaults to the aws\_region if not set | `string` | `""` | no |
| <a name="input_s3_instance_profile"></a> [s3\_instance\_profile](#input\_s3\_instance\_profile) | Optional: String that defines the name of the IAM Instance Profile that grants S3 access to the EC2 instances. Required if 'byo\_certs\_bucket\_path' is set | `string` | `""` | no |
| <a name="input_sensitive_token"></a> [sensitive\_token](#input\_sensitive\_token) | Boolean that determines if the module should treat the generated Rancher Admin API Token as sensitive in the output. | `bool` | `true` | no |
| <a name="input_server_k3s_exec"></a> [server\_k3s\_exec](#input\_server\_k3s\_exec) | exec args to pass to k3s server | `string` | `null` | no |
| <a name="input_ssh_key_path"></a> [ssh\_key\_path](#input\_ssh\_key\_path) | Path to the private SSH key file to be used for connecting to the node(s) | `string` | `null` | no |
| <a name="input_ssh_keys"></a> [ssh\_keys](#input\_ssh\_keys) | SSH keys to inject into Rancher instances | `list(any)` | `[]` | no |
| <a name="input_tls_cert_file"></a> [tls\_cert\_file](#input\_tls\_cert\_file) | Optional: String that defines the name of the TLS Certificate file in the specified S3 bucket's cert tarball. Required if 'byo\_certs\_bucket\_path' is set | `string` | `""` | no |
| <a name="input_tls_key_file"></a> [tls\_key\_file](#input\_tls\_key\_file) | Optional: String that defines the name of the TLS Key file in the specified S3 bucket's cert tarball. Required if 'byo\_certs\_bucket\_path' is set | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certmanager_version"></a> [certmanager\_version](#output\_certmanager\_version) | n/a |
| <a name="output_db_engine_version"></a> [db\_engine\_version](#output\_db\_engine\_version) | n/a |
| <a name="output_db_instance_availability_zone"></a> [db\_instance\_availability\_zone](#output\_db\_instance\_availability\_zone) | The availability zone of the RDS instance |
| <a name="output_db_instance_endpoint"></a> [db\_instance\_endpoint](#output\_db\_instance\_endpoint) | The connection endpoint |
| <a name="output_db_skip_final_snapshot"></a> [db\_skip\_final\_snapshot](#output\_db\_skip\_final\_snapshot) | n/a |
| <a name="output_external_lb_dns_name"></a> [external\_lb\_dns\_name](#output\_external\_lb\_dns\_name) | n/a |
| <a name="output_install_certmanager"></a> [install\_certmanager](#output\_install\_certmanager) | n/a |
| <a name="output_install_monitoring"></a> [install\_monitoring](#output\_install\_monitoring) | n/a |
| <a name="output_install_rancher"></a> [install\_rancher](#output\_install\_rancher) | n/a |
| <a name="output_k3s_cluster_secret"></a> [k3s\_cluster\_secret](#output\_k3s\_cluster\_secret) | n/a |
| <a name="output_k3s_tls_san"></a> [k3s\_tls\_san](#output\_k3s\_tls\_san) | n/a |
| <a name="output_k8s_distribtion"></a> [k8s\_distribtion](#output\_k8s\_distribtion) | n/a |
| <a name="output_rancher_admin_password"></a> [rancher\_admin\_password](#output\_rancher\_admin\_password) | n/a |
| <a name="output_rancher_charts_branch"></a> [rancher\_charts\_branch](#output\_rancher\_charts\_branch) | n/a |
| <a name="output_rancher_charts_repo"></a> [rancher\_charts\_repo](#output\_rancher\_charts\_repo) | n/a |
| <a name="output_rancher_token"></a> [rancher\_token](#output\_rancher\_token) | n/a |
| <a name="output_rancher_url"></a> [rancher\_url](#output\_rancher\_url) | n/a |
| <a name="output_rancher_version"></a> [rancher\_version](#output\_rancher\_version) | n/a |
| <a name="output_server_k3s_exec"></a> [server\_k3s\_exec](#output\_server\_k3s\_exec) | n/a |
| <a name="output_tls_cert_file"></a> [tls\_cert\_file](#output\_tls\_cert\_file) | n/a |
| <a name="output_tls_key_file"></a> [tls\_key\_file](#output\_tls\_key\_file) | n/a |
| <a name="output_use_new_bootstrap"></a> [use\_new\_bootstrap](#output\_use\_new\_bootstrap) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
