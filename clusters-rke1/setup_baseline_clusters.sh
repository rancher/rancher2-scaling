#!/bin/bash -e

cluster_instances=${1:-3}
workspace_prefix="baseline"

echo "checking if workspaces exist"
# This will not fix a broken terraform run, if the workspace already exists it will
# be skipped
for cluster_instance in $(seq -f "%05g" 1 ${cluster_instances}); do
  workspace=${workspace_prefix}-${cluster_instance}
  if [ ! -d "$PWD/terraform.tfstate.d/${workspace}" ];
  then
    # Workspace doesn't exist yet
    echo "provisioning ${cluster_instances} sets of clusters"
    terraform workspace new "${workspace}" || terraform workspace select "${workspace}"
    # Force creation of cluster requirements and usage of auto-generated names
    terraform apply -auto-approve -var "create_node_reqs=true" -var "cluster_name=" -var "wait_for_active=true" -var "cloud_cred_name=" -var "node_template_name="
  elif [ "${cluster_instance}" -eq "${cluster_instances}" ]
  then
    echo "${workspace} already exists!"
    exit 1;
  fi
done

terraform workspace select default
