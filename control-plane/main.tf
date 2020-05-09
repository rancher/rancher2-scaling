terraform {
  required_version = ">= 0.12"
}

terraform {
  backend "local" {
    path = "rancher.tfstate"
  }
}

provider "aws" {
  region  = "us-east-2"
  profile = "rancher-eng"
}

provider "aws" {
  region  = "us-east-2"
  profile = "rancher-eng"
  alias   = "r53"
}

provider "helm" {
  install_tiller  = true
  namespace       = "kube-system"
  service_account = "tiller"

  kubernetes {
    config_path = local_file.kube_cluster_yaml.filename
  }
}

provider "rancher2" {
  alias     = "bootstrap"
  api_url   = "https://${local.name}.${local.domain}"
  bootstrap = true
  insecure  = var.self_signed
}

data "aws_caller_identity" "current" {}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  name   = "default"
}

data "aws_route53_zone" "selected" {
  name         = "${local.domain}."
  private_zone = false
}

resource "random_pet" "identifier" {
  keepers = {
  }
  prefix = var.random_prefix
  length = 1

}

locals {
  domain      = "eng.rancher.space"
  name        = random_pet.identifier.id
  identifier  = random_pet.identifier.id
  db_multi_az = false
}

resource "random_password" "rancher_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

module "k3s" {
  source                      = "./modules/aws-k3s"
  vpc_id                      = data.aws_vpc.default.id
  private_subnets_cidr_blocks = ["172.31.48.0/20", "172.31.0.0/20", "172.31.16.0/20", "172.31.32.0/20"]
  name                        = local.name
  user                        = data.aws_caller_identity.current.user_id
  db_user                     = var.db_username
  db_pass                     = var.db_password
  db_port                     = var.db_port
  db_name                     = var.db_name
  db_security_group           = aws_security_group.database.id
  k3s_datastore_endpoint      = module.db.this_db_instance_endpoint
  k3s_storage_engine          = var.db_engine
  ssh_keys                    = var.ssh_keys
  install_rancher             = true
  rancher_password            = var.rancher_password != null ? var.rancher_password : random_password.rancher_password.result
  rancher_image               = var.rancher_image
  rancher_image_tag           = var.rancher_image_tag
  server_instance_type        = var.rancher_instance_type
  server_node_count           = var.rancher_node_count
  install_k3s_version         = var.install_k3s_version
  server_k3s_exec             = var.server_k3s_exec
  self_signed                 = var.self_signed
}
