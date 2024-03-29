#!/bin/bash -e
IFS=$'\n'

terraform workspace select default
var_file="${1:-terraform.tfvars}"
workspace_prefix="${2:-bulk}"
workspaces=$(terraform workspace list | grep "${workspace_prefix}" | sed 's/*/ /' | sort -r )
timeout=${3:-30}

for workspace in ${workspaces}; do
	workspace="$(echo -e ${workspace} | tr -d '[:space:]')"
	if [ ${workspace} == "default" ]; then
		continue
	fi
  echo "destroying workspace: ${workspace}"
	terraform workspace select "${workspace}"
	terraform destroy -auto-approve -var-file=${var_file} "${@:4}"
  terraform workspace select default
  terraform workspace delete "${workspace}"
  sleep ${timeout};
done

rm -rf terraform.tfstate.d/${workspace_prefix}*
terraform workspace select default
