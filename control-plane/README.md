## Control plane usage:
#### Creating cluster resources
Initialize terraform default workspace. This only needs to be run once to create the initial workspace environment:
```bash
cd control-plane
terraform init
``` 
Create k3s cluster with **mariadb** data store:

```bash
terraform apply
``` 
Creating the cluster resources takes about 10-15 minutes. After successfully running `apply` terraform will output information needed to connect to the rancher server.

#### Destroying cluster resources

```bash
terraform destroy
``` 

Destroying cluster resources takes about 10-15 minutes.

### Configuration:
Configuration changes should be done in `terraform.tfvars` to override default variable settings in `variables.tf`. The format of the `terraform.tfvars` file must be in done with key/value pairs. 

### Example terraform.tfvars file:
```
ssh_keys              = ["<ssh_key>"]
db_name               = "loadup"
rancher_node_count    = 3
rancher_instance_type = "m5.2xlarge"
rancher_password      = "superSecure123@62"
install_k3s_version   = "1.17.3-rc1+k3s1"
random_prefix         = "rancher"
server_k3s_exec       = " --write-kubeconfig-mode '0666'"
```