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
  printf "Iterating over etcd pods in %s\n" "$workspace"
  for etcdpod in $(kubectl --kubeconfig ./files/kube_config/${workspace}_kube_config -n kube-system get pod -l component=etcd --no-headers -o custom-columns=NAME:.metadata.name);
  do
    printf "Getting etcd perf results for %s\n" "$etcdpod"
    { printf "\nNumber of Workspaces: %s" "$num_workspaces"; printf "Getting etcd perf results for %s\n" "$etcdpod"; } >> "./files/etcd_perf/etcd_perf_${workspace}.txt"
    kubectl --kubeconfig ./files/kube_config/${workspace}_kube_config -n kube-system exec $etcdpod -- sh -c "ETCDCTL_ENDPOINTS='https://127.0.0.1:2379' ETCDCTL_CACERT='/var/lib/rancher/rke2/server/tls/etcd/server-ca.crt' ETCDCTL_CERT='/var/lib/rancher/rke2/server/tls/etcd/server-client.crt' ETCDCTL_KEY='/var/lib/rancher/rke2/server/tls/etcd/server-client.key' ETCDCTL_API=3 etcdctl check perf -w fields" >> "./files/etcd_perf/etcd_perf_${workspace}.txt"
  done
done < <(terraform workspace list | tr -cd '\n[:alnum:]-' | grep "workspace")
