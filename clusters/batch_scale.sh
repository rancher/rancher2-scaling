#!/usr/bin/env bash

KUBE_CONFIG=${1}
BATCH_NUM_NODES=${2:-5}
TARGET_NUM_DOWNSTREAMS=${3:-150}

echo "BATCH_NUM_NODES: ${BATCH_NUM_NODES} TARGET_NUM_DOWNSTREAMS: ${TARGET_NUM_DOWNSTREAMS}"

export KUBECONFIG="${KUBE_CONFIG}"

function get_heap_logs() {
    for pod in $(kubectl -n cattle-system get pods --no-headers -l status.phase=Running -l app=rancher | grep Running | cut -d ' ' -f1); do
        echo "getting mem profile for \"${pod}\""
        kubectl -n cattle-system exec "${pod}" -- curl -s http://localhost:6060/debug/pprof/heap -o mem-profile.log
        kubectl -n cattle-system cp "${pod}:mem-profile.log" "${pod}-${1}_clusters-heap.log"
        echo "saved memory profile \"${pod}-${1}_clusters-heap.log\""
    done
}

function get_profile_logs() {
    for pod in $(kubectl -n cattle-system get pods --no-headers -l status.phase=Running -l app=rancher | grep Running | cut -d ' ' -f1); do
        echo "getting cpu profile for \"${pod}\""
        kubectl -n cattle-system exec "${pod}" -- curl -s http://localhost:6060/debug/pprof/profile -o cpu-profile.log
        kubectl -n cattle-system cp "${pod}:cpu-profile.log" "${pod}-${1}_clusters-profile.log"
        echo "saved cpu profile \"${pod}-${1}_clusters-profile.log\""
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

function batch_scale() {
    counter=1
    NUM_BATCHES=$((TARGET_NUM_DOWNSTREAMS / (BATCH_NUM_NODES)))
    HALF_COMPLETE=$(((NUM_BATCHES + 1)/2)) # rounded up
    while [ "${counter}" -le $NUM_BATCHES ]; do
        BATCH_SET_LIMIT=$((counter * BATCH_NUM_NODES))
        echo "Provisioning Cluster Sets: ${BATCH_SET_LIMIT}"
        ./provision_clusters.sh ${BATCH_SET_LIMIT}
        retVal=$?
        if [[ $retVal -eq 1 ]]; then
            echo "Errored, skipping sleep"
        else
            sleep 720
            if [[ "${counter}" -eq $HALF_COMPLETE ]]; then
                get_heap_logs "$(((TARGET_NUM_DOWNSTREAMS + 1)/2))" # rounded up
                get_profile_logs "$(((TARGET_NUM_DOWNSTREAMS + 1)/2))" # rounded up
            fi
        fi
        counter=$((counter + 1))
    done
}

initial_leader=$(get_leader_node)
initial_monitor=$(get_monitor_node)

batch_scale

clusters_reached=$(kubectl get clusters -A --no-headers | wc -l | xargs)
get_heap_logs "${clusters_reached}"
get_profile_logs "${clusters_reached}"

echo "Reached: ${clusters_reached} downstream clusters"
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
kubectl -n cattle-system logs -l status.phase=Running -l app=rancher -c rancher --timestamps --tail=99999999 > "rancher_logs-${clusters_reached}_clusters.txt"
