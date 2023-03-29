#!/usr/bin/env bash

### This script will loop through all generated kubeconfig files in the "./files" directory based from wherever the script was invoked.
### It will look for kubeconfig files matching the pattern of "workspace-XXXXX_kube_config", where each X = a number. It will then execute the etcdctl del --prefix /etcdctl-check-perf/ command.
### $1 - ssh key path
### $2 - ssh user (ex: "root", "ubuntu", etc.)

while read -r workspace
do
    while read -r node
    do
        printf "Deleting etcdctl keys for $node\n"
        ssh -n -o "StrictHostKeyChecking no" -i "${1}" -T "${2}@${node}" "sudo -s sleep 5 && docker exec etcd etcdctl del --prefix /etcdctl-check-perf/"
    done < <(kubectl --kubeconfig ./files/kube_config/${workspace}_kube_config get nodes -o wide | grep etcd | tr -s ' ' | cut -d ' ' -f6)
done < <(terraform workspace list | tr -cd '\n[:alnum:]-' | grep "workspace")
