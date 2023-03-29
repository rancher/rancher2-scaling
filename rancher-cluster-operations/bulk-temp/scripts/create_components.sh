#!/bin/bash

iterations=${1:-1}
var_file="${2:-terraform.tfvars}"
workspace_prefix="${3:-bulk}"
# tf_args=${@:4}

echo "VAR FILE: ${var_file}"
# echo "TF ARGS: ${tf_args}"
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
    terraform apply -auto-approve -var-file="${var_file}" "${@:4}" -parallelism=10;
    sleep 30;
  elif [ "${iter}" -eq "${iterations}" ]
  then
    echo "${workspace} already exists!";
    exit 1;
  fi
done

terraform workspace select default;
