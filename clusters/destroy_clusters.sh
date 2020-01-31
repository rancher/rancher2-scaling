#!/bin/bash -e
IFS=$'\n'

terraform workspace select default
workspace_prefix="workspace"
workspaces=$(terraform workspace list | grep ${workspace_prefix} )

for workspace in ${workspaces}; do
	workspace="$(echo -e ${workspace} | tr -d '[:space:]')"
	if [ ${workspace} == "default" ]; then
		continue
	fi
  echo "destroying workspace: ${workspace}"
	terraform workspace select "${workspace}"
	terraform destroy --auto-approve
  terraform workspace select default
  terraform workspace delete "${workspace}"

done

terraform workspace select default
