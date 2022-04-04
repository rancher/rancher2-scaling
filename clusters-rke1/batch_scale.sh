#!/usr/bin/env bash

KUBE_CONFIG=${1}
BATCH_NUM_NODES=${2:-50}
TARGET_NUM_DOWNSTREAMS=${3:-150}

export KUBECONFIG="${KUBE_CONFIG}"

function get_heap_logs() {
    for pod in $(kubectl -n cattle-system get pods --no-headers -l app=rancher | cut -d ' ' -f1); do
        echo getting profile for "${pod}"
        kubectl -n cattle-system exec "${pod}" -- curl -s http://localhost:6060/debug/pprof/heap -o profile.log
        kubectl -n cattle-system cp "${pod}:profile.log" "${pod}-${1}_clusters-heap.log"
        echo saved profile "${pod}-${1}_clusters-heap.log"
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
    local NUM_BATCHES
    local BATCH_SET_LIMIT
    counter=1
    NUM_BATCHES=$((TARGET_NUM_DOWNSTREAMS / BATCH_NUM_NODES))
    HALF_COMPLETE=$(((NUM_BATCHES + 1)/2)) # rounded up
    while [ "${counter}" -le $NUM_BATCHES ]; do
        BATCH_SET_LIMIT=$((counter * BATCH_NUM_NODES))
        echo "Provisioning Cluster Sets: ${BATCH_SET_LIMIT}"
        ./provision_clusters.sh ${BATCH_SET_LIMIT}
        retVal=$?
        if [[ $retVal -eq 1 ]]; then
            echo "Errored, skipping sleep"
        else
            sleep 540
            if [[ "${counter}" -eq $HALF_COMPLETE ]]; then
                get_heap_logs "$(((TARGET_NUM_DOWNSTREAMS + 1)/2))" # rounded up
            fi
        fi
        counter=$((counter + 1))
    done
}

echo "BATCH_NUM_NODES: ${BATCH_NUM_NODES} TARGET_NUM_DOWNSTREAMS: ${TARGET_NUM_DOWNSTREAMS}"

initial_leader=$(get_leader_node)
initial_monitor=$(get_monitor_node)

batch_scale

if [[ "${counter}" -gt $NUM_BATCHES ]]; then
    counter=$NUM_BATCHES
fi

clusters_reached=$((counter * BATCH_NUM_NODES))
get_heap_logs "${clusters_reached}"
echo "Reached: ${clusters_reached} downstream clusters"
leader=$(get_leader_node)
monitor=$(get_monitor_node)

if [[ ${initial_leader} == "${leader}" ]]; then
    echo "Leader node has not changed"
else
    echo "Leader node has changed"
fi

if [[ ${initial_monitor} == "${monitor}" ]]; then
    echo "Monitor node has not changed"
else
    echo "Monitor node has changed"
fi

echo "leader: $(get_leader_node)"
echo "monitor: $(get_monitor_node)"

# Get essentially as many rancher logs as will likely exist
kubectl -n cattle-system logs -l app=rancher -c rancher --timestamps --tail=99999999 > rancher_logs.txt
