#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "net.ipv4.ip_local_port_range = 15000 61000" >> /etc/sysctl.conf
echo "fs.file-max = 12000500" >> /etc/sysctl.conf
echo "fs.nr_open = 20000500" >> /etc/sysctl.conf
echo "net.ipv4.tcp_mem = 10000000 10000000 10000000" >> /etc/sysctl.conf
sysctl -w net.core.rmem_max=8388608
sysctl -w net.core.wmem_max=8388608
sysctl -w net.core.rmem_default=65536
sysctl -w net.core.wmem_default=65536
sysctl -w net.ipv4.tcp_rmem='4096 87380 8388608'
sysctl -w net.ipv4.tcp_wmem='4096 65536 8388608'
sysctl -w net.ipv4.tcp_mem='8388608 8388608 8388608'
sysctl -w net.ipv4.route.flush=1
echo "# <domain> <type> <item>  <value>" >> /etc/security/limits.d/limits.conf
echo "    *       soft  nofile  20000000" >> /etc/security/limits.d/limits.conf
echo "    *       hard  nofile  20000000" >> /etc/security/limits.d/limits.conf
sysctl -p
systemctl disable firewalld --now
apt-get install -y software-properties-common ntp
# swapoff -a