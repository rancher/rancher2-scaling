resource "aws_security_group" "ingress_egress" {
  name        = "${var.name}-Ingress-Egress-sg"
  description = "Ingress and Egress rules for Rancher"
  vpc_id      = var.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH Ingress"
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH Egress"
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"
    from_port   = "443"
    protocol    = "tcp"
    self        = "false"
    to_port     = "443"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "443"
    protocol    = "tcp"
    self        = "false"
    to_port     = "443"
  }

  # allow all outgoing traffic
  #   egress {
  #     from_port = "0"
  #     protocol  = "-1"
  #     self      = "true"
  #     to_port   = "0"
  #   }

  # allow all incoming traffic between nodes
  #   ingress {
  #     from_port = "0"
  #     protocol  = "-1"
  #     self      = "true"
  #     to_port   = "0"
  #   }

  tags = merge({ "ClusterType" = "rke2" }, local.tags)

}

resource "aws_security_group" "rancher" {
  name        = "${var.name}-RancherCommon-sg"
  description = "https://rancher.com/docs/rancher/v2.6/en/installation/requirements/ports/#commonly-used-ports"
  vpc_id      = var.vpc_id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Docker daemon TLS port used by node driver"
    from_port   = "2376"
    protocol    = "tcp"
    self        = "false"
    to_port     = "2376"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Kubernetes API server"
    from_port   = "6443"
    protocol    = "tcp"
    self        = "false"
    to_port     = "6443"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  egress {
    cidr_blocks = ["35.160.43.145/32", "35.167.242.46/32", "52.33.59.17/32"]
    description = "Rancher catalog (git.rancher.io)"
    from_port   = "443"
    protocol    = "tcp"
    self        = "false"
    to_port     = "443"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Calico BGP Port"
    from_port   = "179"
    protocol    = "tcp"
    self        = "false"
    to_port     = "179"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Canal/Flannel VXLAN overlay networking"
    from_port   = "8472"
    protocol    = "udp"
    self        = "false"
    to_port     = "8472"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Canal/Flannel livenessProbe/readinessProbe"
    from_port   = "9099"
    protocol    = "tcp"
    self        = "false"
    to_port     = "9099"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Default port required by Monitoring to scrape metrics from Linux node-exporters"
    from_port   = "9100"
    protocol    = "tcp"
    self        = "false"
    to_port     = "9100"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Default port required by Monitoring to scrape metrics from Windows node-exporters"
    from_port   = "9796"
    protocol    = "tcp"
    self        = "false"
    to_port     = "9796"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Flannel VXLAN overlay networking on Windows cluster"
    from_port   = "4789"
    protocol    = "udp"
    self        = "false"
    to_port     = "4789"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Ingress controller livenessProbe/readinessProbe"
    from_port   = "10254"
    protocol    = "tcp"
    self        = "false"
    to_port     = "10254"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Kubernetes apiserver"
    from_port   = "6443"
    protocol    = "tcp"
    self        = "false"
    to_port     = "6443"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Metrics server communication with all nodes API"
    from_port   = "10250"
    protocol    = "tcp"
    self        = "false"
    to_port     = "10250"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Node driver Docker daemon TLS port"
    from_port   = "2376"
    protocol    = "tcp"
    self        = "false"
    to_port     = "2376"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "NodePort port range"
    from_port   = "30000"
    protocol    = "tcp"
    self        = "false"
    to_port     = "32767"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "NodePort port range"
    from_port   = "30000"
    protocol    = "udp"
    self        = "false"
    to_port     = "32767"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Rancher webhook"
    from_port   = "8443"
    protocol    = "tcp"
    self        = "false"
    to_port     = "8443"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Rancher webhook"
    from_port   = "9443"
    protocol    = "tcp"
    self        = "false"
    to_port     = "9443"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Weave Port"
    from_port   = "6783"
    protocol    = "tcp"
    self        = "false"
    to_port     = "6783"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Weave UDP Ports"
    from_port   = "6783"
    protocol    = "udp"
    self        = "false"
    to_port     = "6784"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "etcd client requests, etcd peer communication"
    from_port   = "2379"
    protocol    = "tcp"
    self        = "false"
    to_port     = "2380"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "ssh"
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  tags = merge({ "ClusterType" = "rke2" }, local.tags)

}
