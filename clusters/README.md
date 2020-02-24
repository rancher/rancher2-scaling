Example terraform.tfvars file:
```
rancher_api_url           = "https://rancher-server.go"
rancher_token_key         = ""
cluster_count             = 15
ec2_instances_per_cluster = 1
k3s_per_node              = 3
server_instance_type      = "m5.xlarge"
worker_instance_type      = "t3.small"
```