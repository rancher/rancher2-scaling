terraform {
  required_version = ">= 0.13"
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "rancher2_cloud_credential" "aws_cloud_cred" {
  count = var.create_node_reqs ? 1 : 0
  name  = var.cloud_cred_name
  amazonec2_credential_config {
    access_key     = var.aws_access_key
    secret_key     = var.aws_secret_key
    default_region = var.aws_region
  }
}

data "rancher2_cloud_credential" "aws_cloud_cred" {
  name = var.create_node_reqs ? rancher2_cloud_credential.aws_cloud_cred[0].name : var.cloud_cred_name
}

resource "rancher2_node_template" "aws_nt" {
  count               = var.create_node_reqs ? 1 : 0
  name                = var.node_template_name
  cloud_credential_id = data.rancher2_cloud_credential.aws_cloud_cred.id
  engine_install_url  = "https://releases.rancher.com/install-docker/${var.install_docker_version}.sh"

  amazonec2_config {
    ami                  = var.aws_ami
    instance_type        = var.instance_type
    region               = var.aws_region
    security_group       = var.security_groups
    subnet_id            = var.subnet_id
    vpc_id               = var.vpc_id
    zone                 = var.zone
    root_size            = var.root_size
    volume_type          = var.volume_type
    iam_instance_profile = var.iam_instance_profile
  }
}

data "rancher2_node_template" "aws_nt" {
  name = var.create_node_reqs ? rancher2_node_template.aws_nt[0].name : var.node_template_name
}

output "id" {
  value = data.rancher2_node_template.aws_nt.id
}

output "name" {
  value = data.rancher2_node_template.aws_nt.name
}

output "node_template" {
  value = data.rancher2_node_template.aws_nt
}
