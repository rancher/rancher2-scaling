#!/bin/bash -e
IFS=$'\n'

terraform workspace select default
workspace_prefix="bulk"
workspaces=$(terraform workspace list | grep "workspace" | sed 's/*/ /' | sort -r )

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

rm -rf terraform.tfstate.d/*
terraform workspace select default
