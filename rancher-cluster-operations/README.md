## What is this for?
This is a collection of convenience component modules for creating various Rancher2 and K8s terraform resources, installing various charts/Apps, etc.

## Rancher Component Modules
* install-common
* charts/rancher-monitoring
* rancher-controller-metrics
* rancher-cloud-credential
* rancher-node-template
* rancher-cluster
* rancher-secret

### Rancher Examples
* rancher-examples/cluster-aws
* rancher-examples/cluster-linode
* rancher-examples/rancher-setup/2.5.x
* rancher-examples/rancher-setup/2.6.x

Examples can be found in the `rancher-examples/` sub-directory, these are meant purely as examples and are not intended to be used as-is. The example modules can be applied and/or modified to aid in understanding how each individual component module can be used.


### Cluster Example Modules
A pre-existing Rancher Local cluster is required and a minimal subset of input variables are exposed to ease exploratory usage.  The `cluster-aws` and `cluster-linode` modules are examples of how to provision downstream nodedriver clusters using Rancher.  These modules will create the following components (not all of which are necessary for a functioning cluster): `rancher2_cloud_credential`, `rancher2_node_template`, `rancher2_node_pool`, `rancher2_cluster`, `rancher2_secret` or `rancher2_secret_v2`.

### Rancher Setup Example Modules
These modules require a pre-configured cluster with a valid URL from which the underlying nodes/machines for the  cluster can be reached. A minimal subset of input variables are available and must be provided.  These modules can configure and install the following: cert-manager, Rancher (2.5.x or 2.6.x respectively), rancher-monitoring, custom controllers metrics dashboard (only for Rancher 2.5.x), a Rancher Secret.