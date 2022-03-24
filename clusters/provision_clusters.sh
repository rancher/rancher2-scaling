#!/bin/bash -e

cluster_instances=${1:-1}
workspace_prefix="workspace"

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
    terraform apply -auto-approve
  elif [ "${cluster_instance}" -eq "${cluster_instances}" ]
  then
    echo "${workspace} already exists!"
    exit 1;
  fi
done

terraform workspace select default
