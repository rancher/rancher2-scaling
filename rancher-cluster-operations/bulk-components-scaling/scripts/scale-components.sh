#! /bin/bash -e
current_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" || exit ; pwd -P );
parent_path="$(dirname "$current_path")";

iterations=${1:-1}
prefix=${2:-bulk-components}
component=${3}

function scale_components() {
  iterations=${1:-1}
  var_file="${2:-terraform.tfvars}"
  workspace_prefix="${3:-bulk}"
  tf_args=${@:4}
  printf "TF ARGS: %s\n" "${tf_args[@]}"
  echo "${var_file}"
  echo "checking if workspaces exist"
  ## This will not fix a broken terraform run, if the workspace already exists it will
  ## be skipped
  for iter in $(seq -f "%05g" 1 ${iterations}); do
    workspace=${workspace_prefix}-${iter}
    if [ ! -d "$PWD/terraform.tfstate.d/${workspace}" ];
    then
      # Workspace doesn't exist yet
      echo "provisioning ${iter} sets of clusters";
      terraform workspace new "${workspace}" || terraform workspace select "${workspace}";
      terraform apply -auto-approve -var-file="${var_file}" "${tf_args[@]}" -parallelism=10;
      sleep 20;
    elif [ "${iter}" -eq "${iterations}" ]
    then
      echo "${workspace} already exists!";
      exit 1;
    fi
  done

  terraform workspace select default;
}

if [ ! -d "$PWD/terraform.tfstate.d/${prefix}" ];
then
  terraform workspace new ${prefix}
fi
terraform apply -auto-approve -var-file="${current_path}/components-terraform.tfvars"
cluster_name=$(terraform output -json | jq -r '.. | objects | with_entries(select(.key | contains("cluster"))) | select(. != {})[].value | select (. != null)');
export KUBECONFIG="./files/kube_config/.${prefix}-tfkubeconfig"
cd ../bulk-components && scale_components ${iterations} "${current_path}/components-terraform.tfvars" "${prefix}" -var="cluster_name=${cluster_name}";
