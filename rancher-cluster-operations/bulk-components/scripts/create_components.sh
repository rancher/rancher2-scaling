#!/bin/bash -e

iterations=${1:-1}
workspace_prefix="workspace"

echo "checking if workspaces exist"
# This will not fix a broken terraform run, if the workspace already exists it will
# be skipped
for iter in $(seq -f "%05g" 1 ${iterations}); do
  workspace=${workspace_prefix}-${iter}
  if [ ! -d "$PWD/terraform.tfstate.d/${workspace}" ];
  then
    # Workspace doesn't exist yet
    echo "provisioning ${iter} sets of clusters";
    terraform workspace new "${workspace}" || terraform workspace select "${workspace}";
    terraform apply -auto-approve;
    sleep 300;
  elif [ "${iter}" -eq "${iterations}" ]
  then
    echo "${workspace} already exists!";
    exit 1;
  fi
done

terraform workspace select default;
