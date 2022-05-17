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
    # only create cloud credential and node_template if they have not already been created (if first tf apply is successful then skip creation)
    if [ ! ${cluster_instance} = "00001" ] && terraform workspace list | grep -q "${workspace_prefix}-00001";
    then
      terraform apply -auto-approve -var "create_credential=false"
    else
      terraform apply -auto-approve
    fi
  elif [ "${cluster_instance}" -eq "${cluster_instances}" ]
  then
    echo "${workspace} already exists!"
    exit 1;
  fi
done

terraform workspace select default
