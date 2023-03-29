#!/usr/bin/env bash

%{ if !install_certmanager && install_byo_certs ~}
mkdir /certs/
cd certs/
apt-get update \
 && apt-get install atool --yes \
 && apt-get install awscli --yes \
 && aws --region "${s3_bucket_region}" s3 cp s3://"${byo_certs_bucket_path}" /certs/temp_cert

# tar -xf certs.tar.gz --strip-components 1
atool -X ./ temp_cert # NOTE: the given archive must contain a certs/ directory in which all cert files are stored for this to work
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
