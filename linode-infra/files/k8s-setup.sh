#!/bin/bash -xe
exec > >(tee -a /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

apt-get update
apt-get install -y apt-transport-https ca-certificates curl
# curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
# echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
# apt-get update

# remove kubectl
# apt-get purge -y kubectl

# enable required kernel modules
for module in br_netfilter ip6_udp_tunnel ip_set ip_set_hash_ip ip_set_hash_net iptable_filter iptable_nat iptable_mangle iptable_raw nf_conntrack_netlink nf_conntrack nf_defrag_ipv4 nf_nat nfnetlink udp_tunnel veth vxlan x_tables xt_addrtype xt_conntrack xt_comment xt_mark xt_multiport xt_nat xt_recent xt_set xt_statistic xt_tcpudp;
     do
       if ! lsmod | grep -q $module; then
         echo "module $module is not present";
         modprobe $module
       fi;
done

# install kubectl
# apt-get install -y kubectl

# turn swap off
echo "swapoff -a" >> /etc/fstab

# Open TCP/6443 for all
iptables -A INPUT -p tcp --dport 6443 -j ACCEPT
# set recommended networking options
sysctl -w net.bridge.bridge-nf-call-iptables=1
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.bridge.bridge-nf-call-ip6tables=1
sysctl --system

echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config
systemctl restart ssh

until [ "$(pgrep -f --count ssh)" -ge 3 ]; do
  sleep 2
done
