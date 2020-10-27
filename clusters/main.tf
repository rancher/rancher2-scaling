terraform {
  required_version = ">= 0.13"
  required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
      version = "1.10.3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.12.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }
}

terraform {
  backend "local" {
    path = "rancher.tfstate"
  }
}

locals {
  name                = var.cluster_name
  cluster_count       = var.cluster_count
  cluster_instance    = terraform.workspace
  nodes_per_cluster   = var.ec2_instances_per_cluster
  k3s_cluster_secret  = ""
  install_k3s_version = "v1.17.2+k3s1"
}

provider "aws" {
  region  = "us-east-2"
  profile = "rancher-eng"
}

provider "rancher2" {
  api_url   = var.rancher_api_url
  token_key = var.rancher_token_key
}

resource "rancher2_cluster" "k3s" {
  count       = local.cluster_count
  name        = "${local.name}-${local.cluster_instance}-${count.index}"
  description = "TF imported cluster ${local.name}-${local.cluster_instance}-${count.index}"
}

resource "aws_instance" "k3s-server" {
  ebs_optimized = true
  instance_type = var.server_instance_type
  ami           = data.aws_ami.ubuntu.id
  # spot_price           = "1.591"
  # wait_for_fulfillment = true
  # spot_type            = "one-time"
  user_data = templatefile("${path.module}/files/server_userdata.tmpl",
    {
      cluster_count         = local.cluster_count,
      k3s_cluster_secret    = local.k3s_cluster_secret,
      install_k3s_version   = local.install_k3s_version,
      k3s_server_args       = var.k3s_server_args,
      registration_commands = rancher2_cluster.k3s[*].cluster_registration_token[0].command
    }
  )

  tags = {
    Name           = "${local.name}-server-${local.cluster_instance}"
    RancherScaling = var.cluster_name
  }

  root_block_device {
    volume_size = "32"
    volume_type = "gp2"
  }
  depends_on = [rancher2_cluster.k3s]
}
