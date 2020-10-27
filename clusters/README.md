This terraform is for creating the downstream clusters to test Ranchers scaling ability

First create a `terraform.tfvars` file.

This `terraform.tfvars` is the optimal config to max out the host with maximum number of clusters that be ran in it. 
Sometimes a cluster won't provision so in a large run there may be some clusters that never provision. That is fine and expected as the hosts are packed with k3s clusters.

```
rancher_api_url           = "https://rancher-server.go"
rancher_token_key         = ""
cluster_count             = 15
ec2_instances_per_cluster = 1
k3s_per_node              = 3
server_instance_type      = "m5.xlarge"
worker_instance_type      = "t3.small"
```

The total number of clusters will be `N` * `cluster_count` from the `terraform.tfvars` file

To run call `provision_clusters.sh N` where `N` is the number of hosts required. AWS credentials will be required so they can either be set in the env or on the command line when calling the script

To cleanup, there is a `destroy_clusters.sh` however this will also delete all the clusters from Rancher and with the cluster GC being slow this can take a long time (hours) on a large setup. The faster way, assuming the control plane is coming down as well, is to just delete the hosts from AWS and tear down the control plane.
