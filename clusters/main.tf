terraform {
  required_version = ">= 0.13"
  required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
    }
    aws = {
      source  = "hashicorp/aws"
    }
    template = {
      source  = "hashicorp/template"
    }
  }
}

terraform {
  backend "local" {
    path = "rancher.tfstate"
  }
}

locals {
  aws_region          = var.aws_region
  name                = var.cluster_name
  cluster_count       = var.cluster_count
  cluster_instance    = terraform.workspace
  k3s_cluster_secret  = var.k3s_cluster_secret
  install_k3s_image   = var.install_k3s_image
  k3d_version         = var.k3d_version
  ssh_keys            = var.ssh_keys
  insecure_flag       = var.insecure_flag
}

provider "aws" {
  region  = "${local.aws_region}"
  profile = "rancher-eng"
}

provider "rancher2" {
  api_url   = var.rancher_api_url
  token_key = var.rancher_token_key
  insecure  = local.insecure_flag
}

resource "rancher2_cluster" "k3s" {
  count       = local.cluster_count
  name        = "${local.name}-${local.cluster_instance}-${count.index}"
  description = "TF imported cluster ${local.name}-${local.cluster_instance}-${count.index}"
  labels      = var.cluster_labels
}

resource "aws_instance" "k3s-server" {
  ebs_optimized = true
  instance_type = var.server_instance_type
  ami           = data.aws_ami.ubuntu.id

  security_groups = var.security_groups
  # spot_price           = "1.591"
  # wait_for_fulfillment = true
  # spot_type            = "one-time"
  user_data = templatefile("${path.module}/files/server_userdata.tmpl",
    {
      cluster_count         = local.cluster_count,
      k3s_cluster_secret    = local.k3s_cluster_secret,
      install_k3s_image     = local.install_k3s_image,
      k3d_version           = local.k3d_version,
      k3s_server_args       = var.k3s_server_args,
      registration_commands = local.insecure_flag ? data.rancher2_cluster.my_cluster[*].cluster_registration_token[0].insecure_command : data.rancher2_cluster.my_cluster[*].cluster_registration_token[0].command,
      ssh_keys              = local.ssh_keys
    }
  )

  tags = {
    Name           = "${local.name}-server-${local.cluster_instance}"
    RancherScaling = var.cluster_name
    Owner          = var.cluster_name
  }

  root_block_device {
    volume_size = "32"
    volume_type = "gp2"
  }

  depends_on = [rancher2_cluster.k3s]
}

output "cluster_registration_commands" {
  description = "The k3s cluster registration command"
  value       = data.rancher2_cluster.my_cluster[*].cluster_registration_token[0].command
}

output "cluster_registration_tokens" {
  description = "The k3s cluster registration token"
  value       = data.rancher2_cluster.my_cluster[*].cluster_registration_token[0]
}