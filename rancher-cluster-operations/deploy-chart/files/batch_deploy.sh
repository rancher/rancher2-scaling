#!/usr/bin/env bash

script_dir=$(dirname "$0")

RANCHER_KUBE_CONFIG=${1} #
BATCH_NUM_DEPLOYMENTS=${2:-10}
TARGET_NUM_DEPLOYMENTS=${3:-100}
namespace=${4}
chart=${5}
downstream_kube_config=${6}

echo "BATCH_NUM_DEPLOYMENTS: ${BATCH_NUM_DEPLOYMENTS} TARGET_NUM_DEPLOYMENTS: ${TARGET_NUM_DEPLOYMENTS}"

function get_heap_logs() {
  for pod in $(kubectl -n cattle-system get pods --no-headers -l status.phase=Running -l app=rancher | grep Running | cut -d ' ' -f1); do
    echo "getting mem profile for \"${pod}\""
    kubectl -n cattle-system exec "${pod}" -- curl -s http://localhost:6060/debug/pprof/heap -o mem-profile.log
    kubectl -n cattle-system cp "${pod}:mem-profile.log" "${pod}-${1}_deployments-heap.log"
    echo "saved memory profile \"${pod}-${1}_deployments-heap.log\""
  done
}

function get_profile_logs() {
  for pod in $(kubectl -n cattle-system get pods --no-headers -l status.phase=Running -l app=rancher | grep Running | cut -d ' ' -f1); do
    echo "getting cpu profile for \"${pod}\""
    kubectl -n cattle-system exec "${pod}" -- curl -s http://localhost:6060/debug/pprof/profile -o cpu-profile.log
    kubectl -n cattle-system cp "${pod}:cpu-profile.log" "${pod}-${1}_deployments-profile.log"
    echo "saved cpu profile \"${pod}-${1}_deployments-profile.log\""
  done
}

function _get_leader_pod() {
  kubectl -n kube-system get configmap cattle-controllers -o jsonpath='{.metadata.annotations.control-plane\.alpha\.kubernetes\.io/leader}' "${@:1}" | jq '.holderIdentity' | tr -d '"'
}

function get_leader_node() {
  local leader_pod=$(_get_leader_pod "${@:1}")
  kubectl -n cattle-system get pod ${leader_pod} -o=jsonpath='{.status.hostIP}' "${@:1}"
}

function get_monitor_node() {
  kubectl get nodes -l monitoring=yes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}'
}

function bulk_create_deployment() {
  ### $1 - number of deployments
  ### $2 - namespace to deploy to
  ### $3 - local chart dir or chart name to deploy
  for ((i = 0; i < $1; i++)); do
    helm install -n "${2}" --create-namespace --generate-name "${3}"
    # helm install -n "${2}" --create-namespace --generate-name "${3}" &>/dev/null
  done
}

function get_num_deployments() {
  deployments=$(kubectl --kubeconfig "${1}" get deployments -n "${2}" -o custom-columns=NAME:.metadata.name | grep -iv NAME | grep "${3}" | wc -l)
  echo -n "${deployments}"
}

function batch_scale() {
  counter=1
  NUM_BATCHES=$((TARGET_NUM_DEPLOYMENTS / (BATCH_NUM_DEPLOYMENTS)))
  HALF_COMPLETE=$(((NUM_BATCHES + 1) / 2)) # rounded up
  while [ "${counter}" -le $NUM_BATCHES ]; do
    BATCH_SET_LIMIT=$((counter * BATCH_NUM_DEPLOYMENTS))
    echo "Creating ${BATCH_SET_LIMIT} deployments"
    export KUBECONFIG="${downstream_kube_config}"
    bulk_create_deployment ${BATCH_NUM_DEPLOYMENTS} "${namespace}" "${chart}"
    retVal=$?
    if [[ $retVal -eq 1 ]]; then
      echo "Errored, skipping sleep"
    else
      sleep 30
      if [[ "${counter}" -eq $HALF_COMPLETE ]]; then
        export KUBECONFIG="${RANCHER_KUBE_CONFIG}"
        get_heap_logs "$(((TARGET_NUM_DEPLOYMENTS + 1) / 2))"    # rounded up
        get_profile_logs "$(((TARGET_NUM_DEPLOYMENTS + 1) / 2))" # rounded up
      fi
    fi
    counter=$((counter + 1))
  done
}

export KUBECONFIG="${RANCHER_KUBE_CONFIG}"

initial_leader=$(get_leader_node)
initial_monitor=$(get_monitor_node)

batch_scale

export KUBECONFIG="${RANCHER_KUBE_CONFIG}"

deployments_reached=$(get_num_deployments "${downstream_kube_config}" "${namespace}" "mytest")
get_heap_logs "${deployments_reached}"
get_profile_logs "${deployments_reached}"

echo "Reached: ${deployments_reached} chart deployments"
leader=$(get_leader_node)
monitor=$(get_monitor_node)

if [[ ${initial_leader} == "${leader}" ]]; then
  echo "Leader node has not changed"
else
  echo "Leader node (${initial_leader}) has changed"
fi

if [[ ${initial_monitor} == "${monitor}" ]]; then
  echo "Monitor node has not changed"
else
  echo "Monitor node (${initial_monitor}) has changed"
fi

echo "leader: $(get_leader_node)"
echo "monitor: $(get_monitor_node)"

# Get essentially as many rancher logs as will likely exist
kubectl -n cattle-system logs -l status.phase=Running -l app=rancher -c rancher --timestamps --tail=99999999 >"rancher_logs-${deployments_reached}_deployments.txt"
