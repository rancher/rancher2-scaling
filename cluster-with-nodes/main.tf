terraform {
  backend "local" {
    path = "rancher.tfstate"
  }
}

locals {
  name                 = "load-testing"
  instances_per_cluster = var.ec2_instances_per_cluster
  cluster_instance     = terraform.workspace
  k3s_token            = var.k3s_token
  install_k3s_version  = "docker.io/rancher/k3s:v1.17.2-k3s1"
}

provider "aws" {
  region  = "us-west-2"
  //profile = "rancher-eng"
}

provider "rancher2" {
  api_url   = var.rancher_api_url
  token_key = var.rancher_token_key
}

resource "rancher2_cluster" "k3s" {
  name        = "${local.name}-${local.cluster_instance}"
  description = "TF imported cluster ${local.name}-${local.cluster_instance}"
}

resource "aws_spot_instance_request" "k3s-server" {
  //ebs_optimized        = true
  instance_type        = var.server_instance_type
  ami                  = data.aws_ami.ubuntu.id
  spot_price           = var.worker_instance_max_price
  wait_for_fulfillment = true
  spot_type            = "one-time"
  user_data = templatefile("${path.module}/files/server_userdata.tmpl",
    {
      k3s_token             = local.k3s_token,
      install_k3s_version   = local.install_k3s_version,
      registration_commands = rancher2_cluster.k3s[*].cluster_registration_token[0].command
    }
  )

  tags = {
    Name = "${local.name}-server-${local.cluster_instance}"
    RancherScaling = "true"
  }

  root_block_device {
    volume_size = "32"
    volume_type = "gp2"
  }
  depends_on = [rancher2_cluster.k3s]
}

module "downstream-k3s-nodes" {
  source = "./modules/downstream-k3s-nodes"
  k3s_agents_per_node = var.k3s_agents_per_node
  instances = var.ec2_instances_per_cluster
  worker_instance_type = var.worker_instance_type

  ami_id = data.aws_ami.ubuntu.id
  spot_price = var.worker_instance_max_price
  prefix = local.name
  k3s_token = local.k3s_token
  k3s_endpoint = "https://${aws_spot_instance_request.k3s-server.private_ip}:6443"
  install_k3s_version = local.install_k3s_version
}