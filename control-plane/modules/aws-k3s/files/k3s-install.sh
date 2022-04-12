#!/bin/bash

curl -o ${k3s_datastore_cafile} https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem

export INSTALL_K3S_VERSION='v${install_k3s_version}'
export INSTALL_K3S_EXEC='%{ if is_k3s_server }${k3s_tls_san} ${k3s_disable_agent} ${k3s_deploy_traefik} %{ endif ~} ${k3s_exec}'
export K3S_CLUSTER_SECRET='${k3s_cluster_secret}'
export K3S_TOKEN='${k3s_cluster_secret}'
%{~ if use_custom_datastore }
export K3S_DATASTORE_CAFILE='${k3s_datastore_cafile}'
export K3S_DATASTORE_ENDPOINT='${k3s_datastore_endpoint}'
%{~ endif ~}

%{~ if !is_k3s_server }
export K3S_URL='https://${k3s_url}:6443'
%{~ endif ~}

%{ if sleep_at_startup }
sleep_time=$(((RANDOM % 10) + 5))
sleep $sleep_time
%{ endif ~}

until (curl -sfL https://get.k3s.io |  sh -); do
  echo 'k3s did not install correctly'
  systemctl status k3s.service
  journalctl -xe --no-pager
  k3s-uninstall.sh
  sleep 2
done

%{~ if is_k3s_server ~}
until kubectl get pods -A | grep 'Running';
do
  echo 'Waiting for k3s startup'
  sleep 5
done
echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' >> ~/.bashrc
echo 'source <(kubectl completion bash)' >>~/.bashrc
%{~ endif ~}
