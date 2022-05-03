terraform {
  required_version = ">= 0.13"
  required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
      version = "1.21.0"
    }
    aws = {
      source = "hashicorp/aws"
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
  subnet_ids_list          = tolist(data.aws_subnets.available.ids)
  subnet_ids_random_index  = random_id.index.dec % length(local.subnet_ids_list)
  instance_subnet_id       = local.subnet_ids_list[local.subnet_ids_random_index]
  rancher_subdomain        = split(".", split("//", "${var.rancher_api_url}")[1])[0]
  cloud_cred_name          = length(var.existing_cloud_cred) > 0 ? var.existing_cloud_cred : "${local.rancher_subdomain}-aws-cloud-cred"
  roles_map = { for idx, pool in var.roles_per_pool : "node-pool-${idx}" => {
    "control_plane_role" = contains(split(",", pool), "control-plane")
    "worker_role"        = contains(split(",", pool), "worker")
    "etcd_role"          = contains(split(",", pool), "etcd")
    }
  }
  security_groups = [for group in data.aws_security_group.selected : group.name]
  cluster_name    = "${local.rancher_subdomain}-${var.cluster_name}-${terraform.workspace}"
}

resource "rancher2_cloud_credential" "shared_cred" {
  count = var.create_credential ? 1 : 0

  name = local.cloud_cred_name
  amazonec2_credential_config {
    access_key     = var.aws_access_key
    secret_key     = var.aws_secret_key
    default_region = var.aws_region
  }
}

resource "rancher2_machine_config_v2" "aws" {
  generate_name = "${local.cluster_name}-np"
  amazonec2_config {
    ami                  = data.aws_ami.ubuntu.id
    region               = var.aws_region
    security_group       = local.security_groups
    subnet_id            = local.instance_subnet_id
    vpc_id               = data.aws_vpc.default.id
    zone                 = local.selected_az_suffix
    iam_instance_profile = var.iam_instance_profile
    instance_type        = var.server_instance_type
    ssh_user             = "ubuntu"
    tags                 = "RancherScaling,${var.cluster_name},Owner,${var.cluster_name}"
    volume_type          = var.volume_type
    root_size            = var.volume_size
  }
}

resource "rancher2_cluster_v2" "rke2" {
  name               = local.cluster_name
  labels             = var.cluster_labels
  kubernetes_version = var.rke2_version

  rke_config {
    dynamic "machine_pools" {
      for_each = local.roles_map
      content {
        name                         = machine_pools.key
        cloud_credential_secret_name = data.rancher2_cloud_credential.existing_cred.id
        control_plane_role           = machine_pools.value["control_plane_role"]
        worker_role                  = machine_pools.value["worker_role"]
        etcd_role                    = machine_pools.value["etcd_role"]
        quantity                     = var.nodes_per_pool

        machine_config {
          kind = rancher2_machine_config_v2.aws.kind
          name = rancher2_machine_config_v2.aws.name
        }
      }
    }
  }

  depends_on = [
    data.rancher2_cloud_credential.existing_cred
  ]
}
