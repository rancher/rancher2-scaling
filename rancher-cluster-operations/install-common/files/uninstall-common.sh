#!/bin/bash
KUBECONFIG="${1}"
cert_manager_version="${2:1.8.1}"

export KUBECONFIG="${KUBECONFIG}"

curl -s https://raw.githubusercontent.com/rancher/rancher-cleanup/main/deploy/rancher-cleanup.yaml | kubectl create -f - &&
  curl -s https://raw.githubusercontent.com/rancher/rancher-cleanup/main/deploy/verify.yaml | kubectl create -f -

helm uninstall cert-manager --namespace cert-manager &&
  kubectl delete namespace cert-manager &&
  kubectl delete -f "https://github.com/cert-manager/cert-manager/releases/download/v${cert_manager_version}/cert-manager.crds.yaml"
