#!/usr/bin/env bash

### This script will loop through all generated kubeconfig files in the "./files" directory based from wherever the script was invoked.
### It will look for kubeconfig files matching the pattern of ".workspace-XXXXX_kube_config", where each X = a number. It will then execute the etcdctl check perf command.
### Example invocation when executing within "clusters-rke1/linode": ../check_etcd_perf.sh ~/.ssh/<ssh key with access to all nodes> root
### $1 - ssh key path
### $2 - ssh user (ex: "root", "ubuntu", etc.)

mkdir -p "./files/kube_config"
mkdir -p "./files/etcd_perf"
num_workspaces=$(terraform workspace list | awk 'NR > 1 {print $1}')
while read -r workspace
do
    while read -r node
    do
        printf "Getting etcd perf results for %s\n" "$node"
        { printf "\nNumber of Workspaces: %s" "$num_workspaces"; printf "\nGetting etcd perf results for %s" "$node"; } >> "./files/etcd_perf/etcd_perf_${workspace}.txt"
        ssh -n -o "StrictHostKeyChecking no" -i "${1}" -T "${2}@${node}" "sudo -s sleep 5 && docker exec etcd etcdctl check perf -w fields" >> "./files/etcd_perf/etcd_perf_${workspace}.txt"
    done < <(kubectl --kubeconfig ./files/kube_config/${workspace}_kube_config get nodes -o wide | grep etcd | tr -s ' ' | cut -d ' ' -f6)
done < <(terraform workspace list | tr -cd '\n[:alnum:]-' | grep "workspace")
