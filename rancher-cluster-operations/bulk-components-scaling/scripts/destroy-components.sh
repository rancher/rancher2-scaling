#!/bin/bash -e
IFS=$'\n'
current_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" || exit ; pwd -P );
parent_path="$(dirname "$current_path")";

prefix=${1}

function destroy_components() {
  terraform workspace select default
  var_file="${1:-terraform.tfvars}"
  workspace_prefix="${2:-bulk}"
  tf_args=${@:3}
  workspaces=$(terraform workspace list | grep "${workspace_prefix}" | sed 's/*/ /' | sort -r )

  for workspace in ${workspaces}; do
    workspace="$(echo -e ${workspace} | tr -d '[:space:]')"
    if [ ${workspace} == "default" ]; then
      continue
    fi
    echo "destroying workspace: ${workspace}"
    terraform workspace select "${workspace}"
    terraform destroy --auto-approve "${tf_args[@]}"
    terraform workspace select default
    terraform workspace delete "${workspace}"

  done

  rm -rf terraform.tfstate.d/${workspace_prefix}*
  terraform workspace select default
}

cluster_name=$(terraform output -json | jq -r '.. | ."${prefix}-cluster"?.value | select(. != null)');
terraform destroy -auto-approve -var-file="${current_path}/components-terraform.tfvars" && terraform workspace select default && terraform workspace delete "bulk-${prefix}";
cd ../bulk-components && destroy_components "${current_path}/components-terraform.tfvars" "bulk-${prefix}" -var="cluster_name=${cluster_name}";
