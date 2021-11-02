#!/bin/bash
node=`kubectl get nodes --sort-by=metadata.name --no-headers | awk 'NR==1{print $1}'`
echo $node
kubectl taint nodes $node monitoring=yes:NoSchedule
kubectl label nodes $node monitoring=yes

%{ if install_certmanager ~}
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v${certmanager_version}/cert-manager.yaml

until [ "$(kubectl get pods --namespace cert-manager | grep Running | wc -l)" = "3" ]; do
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
%{ if !install_certmanager && install_byo_certs ~}
        source: secret
        secretName: tls-rancher-ingress
%{ endif ~}
%{ if install_certmanager ~}
        source: letsEncrypt
    letsEncrypt:
      email: ${letsencrypt_email}
%{ endif ~}
%{ if private_ca ~}
    privateCA: ${private_ca}
%{ endif ~}
    rancherImage: ${rancher_image}
    rancherImageTag: ${rancher_image_tag}
    replicas: ${rancher_node_count}
%{ if use_new_bootstrap ~}
    bootstrapPassword: ${rancher_password}
%{ endif ~}
    extraEnv:
    - name: CATTLE_PROMETHEUS_METRICS
      value: 'true'
EOF
%{ endif }

%{ if !install_certmanager && install_byo_certs ~}
mkdir /certs/
cd certs/
apt-get update && apt-get install awscli --yes && aws --region "${s3_bucket_region}" s3 cp s3://"${byo_certs_bucket_path}" /certs/certs.tar.gz

tar -xf certs.tar.gz --strip-components 1
mv "/certs/${tls_cert_file}" /certs/tls.crt
mv "/certs/${tls_key_file}" /certs/tls.key

if [[ ! $(kubectl get secrets -n cattle-system | grep -q tls-rancher-ingress) ]]; then
  kubectl -n cattle-system create secret tls tls-rancher-ingress \
    --cert="/certs/tls.crt" \
    --key="/certs/tls.key"
fi

%{ if private_ca ~}
mv "/certs/${private_ca_file}" /certs/cacerts.pem
if [[ ! $(kubectl get secrets -n cattle-system | grep -q tls-ca) ]]; then
  kubectl -n cattle-system create secret generic tls-ca \
    --from-file=cacerts.pem="/certs/cacerts.pem"
fi
%{ endif ~}

find . -type f ! -name "*.key" ! -name "*.crt" ! -name "cacerts.pem" -exec rm {} \;

%{ endif ~}

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
  chart: https://raw.githubusercontent.com/rancher/charts/${rancher_chart_tag}/assets/rancher-monitoring/rancher-monitoring-crd-${monitoring_version}.tgz
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
  chart: https://raw.githubusercontent.com/rancher/charts/${rancher_chart_tag}/assets/rancher-monitoring/rancher-monitoring-${monitoring_version}.tgz
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
    prometheus-adapter:
      nodeSelector:
          monitoring: 'yes'
      tolerations:
        - key: monitoring
          operator: Exists
          effect: NoSchedule
    kube-state-metrics:
      nodeSelector:
          monitoring: 'yes'
      tolerations:
        - key: monitoring
          operator: Exists
          effect: NoSchedule
    prometheusOperator:
      nodeSelector:
          monitoring: 'yes'
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
