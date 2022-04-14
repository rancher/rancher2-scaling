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
  region     = "us-west-1"
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
  subnet_ids_list          = tolist(data.aws_subnets.available.ids)
  subnet_ids_random_index  = random_id.index.dec % length(local.subnet_ids_list)
  instance_subnet_id       = local.subnet_ids_list[local.subnet_ids_random_index]
  rancher_subdomain        = split(".", split("//", "${var.rancher_api_url}")[1])[0]
  name_suffix              = try("-${var.name_suffix}", "")
  cloud_cred_name          = "${local.rancher_subdomain}-aws-cloud-cred${local.name_suffix}"
  node_template_name       = "${local.rancher_subdomain}-aws-nt${local.name_suffix}"
  node_pool_name           = "${local.cluster_name}-np${local.name_suffix}"
  cluster_name             = "${local.rancher_subdomain}-aws-${var.cluster_name}-${terraform.workspace}"
}

module "cloud_credential" {
  source         = "../../rancher-cluster-operations/rancher-cloud-credential"
  create_new     = var.create_node_reqs
  name           = local.cloud_cred_name
  cloud_provider = "aws"
  credential_config = {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region     = var.region
  }
}

module "node_template" {
  source                 = "../../rancher-cluster-operations/rancher-node-template"
  create_new             = var.create_node_reqs
  name                   = local.node_template_name
  cloud_cred_id          = module.cloud_credential.id
  install_docker_version = var.install_docker_version
  cloud_provider         = "aws"
  node_config = {
    ami                  = data.aws_ami.ubuntu.id
    instance_type        = var.server_instance_type
    region               = var.region
    security_group       = var.security_groups
    subnet_id            = local.instance_subnet_id
    vpc_id               = data.aws_vpc.default.id
    zone                 = local.selected_az_suffix
    root_size            = var.volume_size
    volume_type          = var.volume_type
    iam_instance_profile = var.iam_instance_profile
  }
}

resource "rancher2_node_pool" "np" {
  count            = var.node_pool_count
  cluster_id       = module.cluster_v1.id
  name             = "${local.node_pool_name}-${count.index}"
  hostname_prefix  = "${local.node_pool_name}-pool${count.index}-node"
  node_template_id = module.node_template.id
  quantity         = var.nodes_per_pool
  control_plane    = true
  etcd             = true
  worker           = true
}

module "cluster_v1" {
  source           = "../../rancher-cluster-operations/rancher-cluster/v1"
  name             = local.cluster_name
  description      = "TF aws nodedriver cluster ${local.cluster_name}"
  labels           = var.cluster_labels
  k8s_distribution = "rke1"
  k8s_version      = var.k8s_version
  cloud_provider   = "aws"
  network_config = {
    plugin = "canal"
    mtu    = null
  }
  upgrade_strategy = {
    drain = false
  }

  depends_on = [
    module.node_template
  ]
}

output "create_node_reqs" {
  value = var.create_node_reqs
}

output "cred_name" {
  value = module.cloud_credential.name
}

output "nt_name" {
  value = module.node_template.name
}
