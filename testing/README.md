# How setup environment
1. `sudo pip install virtualenv`
2. `mkdir -p ~/.venv/rancher-scaling`
3. `virtualenv -p python3 ~/.venv/rancher-scaling`
4. `source ~/.venv/rancher-scaling/bin/activate`
5. `pip install -r requirements.txt`
6. `deactivate`

# How to use
1. `source ~/.venv/rancher-scaling/bin/activate`
2. set environment variable "AWS_ACCESS_KEY_ID" to access key
3. set environment variable "AWS_SECRET_ACCESS_KEY" to secret key

## For full scaling setup and test
4. set environment variable "TF_VAR_cluster_name" to something, preferrably your name, that can be used to distinguish clusters created by this instance ofscale-testing
5. set environment variable "TF_VAR_server_instance_type", at least m5.xlarge is recommended- this is for the nodes containing k3s clusters
6. set environment variable "TF_VAR_k3s_per_node" to 1
7. set environment variable "TF_VAR_TF_VAR_ec2_instances_per_cluster" to 1
8. set environment variable "TF_VAR_cluster_count", this is the number of cluster being put on a single node, 12-15 for m5.xlarge
9. set environment variable "TF_VAR_worker_instance_type", won't be used, so set to t2.small
10. (optional) set environment variable "RANCHER_SCALING_GOAL" to number of desired clusters
11. (optional) set environment variable "TF_VAR_rancher_node_count", default is 1 which is for single rancher install, set to 3 for HA
12. (optional) set environment variable "TF_VAR_rancher_instance_type", default is m5.xlarge- for 1k+ loads m5.4xlarge is recommended
13. (optional) set environment variable "TF_VAR_rancher_image", "TF_VAR_rancher_image_tag", default is rancher/rancher and master respectively
14. (optional) set environment variable "TF_VAR_self_signed", whether to use rancher signed certs, Lets Encrypt will be used if it is false. Default is false
15. (optional) set environment variable "RANCHER_SCALING_CLEANUP". Setup will not be cleaned up automatically unless set to true or True. Default is false

## For just tests
4. set environment variable "RANCHER_SCALING_URL" to rancher url.
5. set environment variable "RANCHER_SCALING_TOKEN" to rancher token.
6. run `python testbench.py`.
7. (optional) can run `jupyter notebook` and select "Scaling Summary".
8. (when done) `deactivate`

# Options
### There are multiple optional parameters that can be configured with environment variables.
### Below are the environment variables that can be set and what they do. If these are not set,
### they will be given default values.

RANCHER_SCALING_PULSE: time to wait between each iteration
RANCHER_SCALING_JITTER: random number within this range will be added to every "pulse" 
RANCHER_SCALING_ITERATIONS: number of times to run full suite of metrics
RANCHER_SCALING_SAVE: amount of time to wait in between saving results to csv
