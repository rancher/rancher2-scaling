# rancher2-scaling

Terraform for running controller plane and downstream clusters
Python for scaling tests


## usage:
#### creating cluster resources
Initialize terraform default workspace. This only needs to be run once to create the initial workspace environment:
```bash
terraform init
``` 
Create k3s cluster with **mariadb** data store:

```bash
terraform apply
``` 
Creating the cluster resources takes about 10-15 minutes.

#### destroying cluster resources

```bash
terraform destroy
``` 
destroying cluster resources takes about 10-15 minutes.

## configuration:
Configuration changes should be done in `terraform.tfvars` to override default variable settings in `variables.tf`. The format of the `terraform.tfvars` file must be in done with key/value pairs. 