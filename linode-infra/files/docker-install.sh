#!/bin/bash -x
exec > >(tee -a /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

apt-get purge -y docker-ce docker-ce-cli containerd.io || true
apt-get remove -y docker docker-engine docker.io containerd runc || true
rm -rf /var/lib/docker
rm -rf /var/lib/containerd

# apt-get update
# apt-get install -y docker-ce docker-ce-cli containerd.io

curl https://releases.rancher.com/install-docker/${install_docker_version}.sh | sh && usermod -aG docker ubuntu

until [ "$(pgrep -f --count dockerd)" -ge 1 ]; do
  sleep 2
done

docker_active=$(systemctl is-active docker.service)
containerd_active=$(systemctl is-active containerd.service)
until [[ $docker_active == "active" && $containerd_active == "active" ]]; do
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
  ### start docker on boot
  systemctl enable docker.service && systemctl enable containerd.service

  docker_active=$(systemctl is-active docker.service)
  containerd_active=$(systemctl is-active containerd.service)
done
# if [ -x "$(command -v docker)" ]; then
#   echo "Docker installed successfully"
# else
#   echo "Docker not installed"
# fi
