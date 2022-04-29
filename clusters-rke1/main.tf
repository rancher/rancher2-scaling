terraform {
  required_version = ">= 0.13"
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
    }
    aws = {
      source = "hashicorp/aws"
    }
    template = {
      source = "hashicorp/template"
    }
    random = {
      source = "hashicorp/random"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

terraform {
  backend "local" {
    path = "rancher.tfstate"
  }
}

provider "rancher2" {
  api_url   = var.rancher_api_url
  token_key = var.rancher_token_key
  insecure  = var.insecure_flag
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "random_id" "index" {
  byte_length = 2
}

locals {
  az_zone_ids_list         = tolist(data.aws_availability_zones.available.zone_ids)
  az_zone_ids_random_index = random_id.index.dec % length(local.az_zone_ids_list)
  instance_az_zone_id      = local.az_zone_ids_list[local.az_zone_ids_random_index]
  selected_az_suffix       = data.aws_availability_zone.selected_az.name_suffix
  subnet_ids_list          = tolist(data.aws_subnet_ids.available.ids)
  subnet_ids_random_index  = random_id.index.dec % length(local.subnet_ids_list)
  instance_subnet_id       = local.subnet_ids_list[local.subnet_ids_random_index]
  rancher_subdomain        = split(".", split("//", "${var.rancher_api_url}")[1])[0]
  cloud_cred_name          = "${local.rancher_subdomain}-aws-cloud-cred"
  node_template_name       = "${local.rancher_subdomain}-aws-nt"
  nt_depends_on            = var.create_node_reqs ? module.shared_node_template[0] : data.rancher2_node_template.existing_nt[0]
  cluster_name             = "${local.rancher_subdomain}-${var.cluster_name}-${terraform.workspace}"
}

module "shared_node_template" {
  count  = var.create_node_reqs ? 1 : 0
  source = "./modules/node-template"

  create_node_reqs       = var.create_node_reqs
  cloud_cred_name        = local.cloud_cred_name
  node_template_name     = local.node_template_name
  aws_access_key         = var.aws_access_key
  aws_secret_key         = var.aws_secret_key
  install_docker_version = var.install_docker_version
  aws_ami                = data.aws_ami.ubuntu.id
  instance_type          = var.server_instance_type
  aws_region             = var.aws_region
  security_groups        = var.security_groups
  subnet_id              = local.instance_subnet_id
  vpc_id                 = data.aws_vpc.default.id
  zone                   = local.selected_az_suffix
  root_size              = var.volume_size
  volume_type            = var.volume_type
  iam_instance_profile   = var.iam_instance_profile
}

resource "null_resource" "nt_dependency" {
  depends_on = [
    local.nt_depends_on
  ]
}

resource "rancher2_node_pool" "np" {
  count            = var.node_pool_count
  cluster_id       = rancher2_cluster.rke1.id
  name             = "${local.cluster_name}-np${count.index}"
  hostname_prefix  = "${local.cluster_name}-pool${count.index}-node"
  node_template_id = local.nt_depends_on.id
  quantity         = var.nodes_per_pool
  control_plane    = true
  etcd             = true
  worker           = true
}

resource "rancher2_cluster" "rke1" {
  name        = local.cluster_name
  description = "TF AWS nodedriver cluster ${local.cluster_name}"
  labels      = var.cluster_labels

  rke_config {
    ignore_docker_version = false
    addon_job_timeout     = 60

    cloud_provider {
      name = "aws"
      aws_cloud_provider {}
    }
    network {
      plugin = "canal"
    }
    upgrade_strategy {
      drain = false
    }
  }
  depends_on = [
    null_resource.nt_dependency
  ]
}
