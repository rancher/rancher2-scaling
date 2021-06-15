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
ssh_keys              = ["<Your key/s here>"]
db_name               = "loadthing"
rancher_node_count    = 3
rancher_instance_type = "m5.large"
rancher_password      = "super-secret-and-long-password"
install_k3s_version   = "1.19.3+k3s1"
random_prefix         = "scale-testing"
server_k3s_exec       = " --write-kubeconfig-mode '0666'"
rancher_image_tag     = "v2.5.1"
rancher_version       = "2.5.1"
monitoring_version    = "9.4.201"
domain                = "your-route53-zone"
letsencrypt_email     = "your@email.com"
```

### Accessing Monitoring
When doing load testing, it is highly likely that the hosts Rancher is running on will die, so attempting to proxy through Rancher to view Grafana is not possible. Monitoring runs on its own node so it wont go down when Rancher or its hosts do. Using `kubectl` Grafana (and anything monitoring related) will still be accessable:
```bash
kubectl port-forward -n cattle-monitoring-system deployment/rancher-monitoring-grafana 8443:3000
```
Then go to `http://127.0.0.1:8443` in a browser to connect back to the Grafana UI.
The port `8443` can be adjusted as need for your local system.
