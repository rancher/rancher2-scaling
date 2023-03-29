#!/bin/bash

function bulk_create_deployment() {
  ### $1 - number of deployments
  ### $2 - namespace to deploy to
  ### $3 - local chart dir or chart name to deploy
  for ((i = 0; i < $1; i++)); do
    helm install -n "${2}" --create-namespace --generate-name "${3}"
    # helm install -n "${2}" --create-namespace --generate-name "${3}" &>/dev/null
  done
}

function bulk_delete_deployment() {
  ### $1 - number of deployments
  ### $2 - namespace to reference
  ### $3 - name of released chart to uninstall
  deployments=$(kubectl get deployments -n "${2}" -o custom-columns=NAME:.metadata.name | grep -iv NAME | grep "${3}")
  i=0
  while read -r LINE; do
    if [ $i -lt $1 ]; then
      kubectl delete deployment "$LINE" -n "${2}"
    fi
    i=$((i + 1))
  done < <(echo "$deployments")
}
