terraform {
  required_version = ">= 0.13"
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
    }
    aws = {
      source = "hashicorp/aws"
    }
    cloudinit = {
      source = "hashicorp/cloudinit"
    }
  }
}

terraform {
  backend "local" {
    path = "rancher.tfstate"
  }
}

locals {
  aws_region         = var.aws_region
  cluster_count      = var.cluster_count
  cluster_instance   = terraform.workspace
  k3s_cluster_secret = var.k3s_cluster_secret
  install_k3s_image  = var.install_k3s_image
  k3d_version        = var.k3d_version
  ssh_keys           = var.ssh_keys
  insecure_flag      = var.insecure_flag
  rancher_subdomain  = split(".", split("//", "${var.rancher_api_url}")[1])[0]
  cluster_name       = "${local.rancher_subdomain}-${var.cluster_name}"
}

provider "aws" {
  region  = local.aws_region
  profile = "rancher-eng"
}

provider "rancher2" {
  api_url   = var.rancher_api_url
  token_key = var.rancher_token_key
  insecure  = local.insecure_flag
}

resource "rancher2_cluster" "k3s" {
  count       = local.cluster_count
  name        = "${local.cluster_name}-${local.cluster_instance}-${count.index}"
  description = "TF imported cluster ${local.cluster_name}-${local.cluster_instance}-${count.index}"
  labels      = var.cluster_labels
}

resource "aws_instance" "k3s-server" {
  ebs_optimized   = true
  instance_type   = var.server_instance_type
  ami             = data.aws_ami.ubuntu.id
  security_groups = var.security_groups
  user_data = templatefile("${path.module}/files/server_userdata.tmpl",
    {
      cluster_count         = local.cluster_count,
      k3s_cluster_secret    = local.k3s_cluster_secret,
      install_k3s_image     = local.install_k3s_image,
      k3d_version           = local.k3d_version,
      k3s_server_args       = var.k3s_server_args,
      registration_commands = local.insecure_flag ? rancher2_cluster.k3s[*].cluster_registration_token[0].insecure_command : rancher2_cluster.k3s[*].cluster_registration_token[0].command,
      ssh_keys              = local.ssh_keys
    }
  )

  tags = {
    Name           = "${local.cluster_name}-server-${local.cluster_instance}"
    RancherScaling = local.cluster_name
    Owner          = local.cluster_name
  }

  root_block_device {
    volume_size = "32"
    volume_type = "gp2"
  }

  depends_on = [rancher2_cluster.k3s]
}

output "cluster_registration_tokens" {
  description = "The k3s cluster registration token"
  value       = rancher2_cluster.k3s[*].cluster_registration_token[0]
}
