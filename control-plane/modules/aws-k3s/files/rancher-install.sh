#!/bin/bash
node=`kubectl get nodes --sort-by=metadata.name --no-headers | awk 'NR==1{print $1}'`
echo $node
kubectl taint nodes $node monitoring=yes:NoSchedule
kubectl label nodes $node monitoring=yes

%{ if install_certmanager ~}
kubectl create namespace cert-manager
kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true
sleep 5
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v${certmanager_version}/cert-manager-no-webhook.yaml

until [ "$(kubectl get pods --namespace cert-manager |grep Running|wc -l)" = "2" ]; do
  sleep 2
done
%{ endif ~}
%{ if install_rancher ~}
cat <<EOF > /var/lib/rancher/k3s/server/manifests/rancher.yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: cattle-system
---
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: rancher
  namespace: kube-system
spec:
  chart: https://releases.rancher.com/server-charts/latest/rancher-${rancher_version}.tgz
  targetNamespace: cattle-system
  valuesContent: |-
    hostname: ${rancher_hostname}
    ingress:
      tls:
        source: letsEncrypt
    letsEncrypt:
      email: ${letsencrypt_email}
    rancherImage: ${rancher_image}
    rancherImageTag: ${rancher_image_tag}
    replicas: 3
    extraEnv:
    - name: CATTLE_PROMETHEUS_METRICS
      value: 'true'
EOF
%{ endif }

cat <<EOF > /var/lib/rancher/k3s/server/manifests/monitoring.yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: cattle-monitoring-system
---
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: rancher-monitoring-crd
  namespace: kube-system
spec:
  chart: https://raw.githubusercontent.com/rancher/charts/release-v2.5/assets/rancher-monitoring/rancher-monitoring-crd-${monitoring_version}.tgz
  targetNamespace: cattle-monitoring-system
  valuesContent: |-
    global:
      cattle:
        clusterId: local
        clusterName: local
        systemDefaultRegistry: ''
      systemDefaultRegistry: ''
---
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: rancher-monitoring
  namespace: kube-system
spec:
  chart: https://raw.githubusercontent.com/rancher/charts/release-v2.5/assets/rancher-monitoring/rancher-monitoring-${monitoring_version}.tgz
  targetNamespace: cattle-monitoring-system
  valuesContent: |-
    alertmanager:
      enabled: false
    grafana:
      nodeSelector:
        monitoring: 'yes'
      tolerations:
      - key: monitoring
        operator: Exists
        effect: NoSchedule
    prometheus:
      prometheusSpec:
        evaluationInterval: 1m
        nodeSelector:
          monitoring: 'yes'
        resources:
          limits:
            memory: 5000Mi
        retentionSize: 50GiB
        scrapeInterval: 1m
        tolerations:
        - key: monitoring
          operator: Exists
          effect: NoSchedule
    global:
      cattle:
        clusterId: local
        clusterName: local
        systemDefaultRegistry: ''
      systemDefaultRegistry: ''
EOF
