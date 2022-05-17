#!/bin/bash
### Values taken from https://github.com/rancher/rke2-charts/blob/main-source/packages/rke2-ingress-nginx/generated-changes/patch/values.yaml.patch
%{ if install_nginx_ingress }
cat <<EOF >/var/lib/rancher/k3s/server/manifests/ingress.yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: ingress-nginx
---
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: ingress-nginx
  namespace: kube-system
spec:
  chart: ingress-nginx
  repo: https://kubernetes.github.io/ingress-nginx
  targetNamespace: ingress-nginx
  version: ${ingress_nginx_version}
  set:
  valuesContent: |-
    fullnameOverride: ingress-nginx
    controller:
      kind: DaemonSet
      dnsPolicy: ClusterFirstWithHostNet
      watchIngressWithoutClass: true
      allowSnippetAnnotations: false
      hostNetwork: true
      hostPort:
        enabled: true
      publishService:
        enabled: false
      service:
        enabled: false
      metrics:
        enabled: false
EOF
kubectl apply -f /var/lib/rancher/k3s/server/manifests/ingress.yaml
%{ endif }
