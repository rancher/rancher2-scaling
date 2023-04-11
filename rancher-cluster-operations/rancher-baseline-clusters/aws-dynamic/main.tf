terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    rancher2 = {
      source = "rancher/rancher2"
    }
    null = {
      source = "hashicorp/null"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

terraform {
  backend "local" {
    path = "rancher.tfstate"
  }
}

provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "rancher2" {
  api_url   = var.rancher_api_url
  token_key = var.rancher_token_key
  insecure  = var.insecure_flag
}

### Used to generate AWS Data
resource "random_id" "index" {
  byte_length = 2
}

### Used to generate randomized ids for cluster names
# resource "random_id" "this" {
#   # count       = length(var.cluster_configs)

#   # prefix      = local.rancher_subdomain
#   byte_length = 4
# }

locals {
  ### AWS Data
  az_zone_ids_list         = tolist(data.aws_availability_zones.available.zone_ids)
  az_zone_ids_random_index = random_id.index.dec % length(local.az_zone_ids_list)
  instance_az_zone_id      = local.az_zone_ids_list[local.az_zone_ids_random_index]
  selected_az_suffix       = data.aws_availability_zone.selected_az.name_suffix
  subnet_ids_list          = tolist(data.aws_subnets.available.ids)
  subnet_ids_random_index  = random_id.index.dec % length(local.subnet_ids_list)
  instance_subnet_id       = local.subnet_ids_list[local.subnet_ids_random_index]
  security_groups          = [for group in data.aws_security_group.selected : group.name]
  ### Naming
  name_max_length   = 60
  rancher_subdomain = split(".", split("//", "${var.rancher_api_url}")[1])[0]
  name_suffix       = length(var.name_suffix) > 0 ? var.name_suffix : "${terraform.workspace}"
  cloud_cred_name   = length(var.cloud_cred_name) > 0 ? var.cloud_cred_name : "${local.rancher_subdomain}-cloud-cred-${local.name_suffix}"
  ### Misc Defaults
  network_config = {
    plugin = "canal"
    mtu    = null
  }
  upgrade_strategy = {
    drain = false
  }
  kube_api = var.kube_api_debugging ? {
    extra_args = {
      v = "3"
    }
  } : null
  ### Cluster and node pool configuration
  cluster_configs = [for i, config in var.cluster_configs : {
    name = substr("${config.k8s_distribution}-${local.name_suffix}${i}", 0, local.name_max_length)
    # id               = random_id.this[i].dec
    k8s_distribution = config.k8s_distribution
    k8s_version      = config.k8s_version
    roles_per_pool   = config.roles_per_pool
  }]
  v1_configs = {
    for i, config in local.cluster_configs :
    i => config if config.k8s_distribution == "rke1"
  }
  v1_pools = flatten([
    for config_key, config in local.v1_configs : [
      for pool_key, pool in config.roles_per_pool : {
        config_key      = config_key
        pool_key        = pool_key
        name            = substr("${config.name}-pool${pool_key}", 0, local.name_max_length)
        hostname_prefix = substr("${config.name}-pool${pool_key}-node", 0, local.name_max_length)
        quantity        = pool.quantity
        etcd            = pool["etcd"]
        control-plane   = pool["control-plane"]
        worker          = pool["worker"]
      }
    ]
  ])
  v1_count = length(keys(local.v1_configs))
  v2_configs = {
    for i, config in local.cluster_configs :
    i => config if contains(["rke2", "k3s"], config.k8s_distribution)
  }
  v2_count            = length(keys(local.v2_configs))
  v1_kube_config_list = rancher2_cluster_sync.cluster_v1[*].kube_config
  v2_kube_config_list = rancher2_cluster_sync.cluster_v2[*].kube_config
  v1_clusters         = values(module.cluster_v1)
  v2_clusters         = values(rancher2_cluster_v2.cluster_v2)
  clusters            = concat(local.v1_clusters[*], local.v2_clusters[*])
  clusters_info = {
    for i, cluster in local.clusters :
    i => {
      id      = try(cluster.cluster_v1_id, cluster.id)
      name    = cluster.name
      project = "baseline-components"
    }
  }
}

module "cloud_credential" {
  source     = "../../rancher-cloud-credential"
  create_new = var.create_node_reqs
  providers = {
    rancher2 = rancher2
  }

  name           = local.cloud_cred_name
  cloud_provider = "aws"
  credential_config = {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region     = var.region
  }
}

resource "rancher2_project" "this" {
  for_each   = { for i, cluster in local.clusters : i => try(cluster.cluster_v1_id, cluster.id) }
  cluster_id = each.value
  name       = "baseline-components"
}

module "bulk_components" {
  for_each = local.clusters_info
  source   = "../../bulk-components"
  providers = {
    rancher2 = rancher2
  }
  rancher_api_url   = var.rancher_api_url
  rancher_token_key = var.rancher_token_key
  output_local_file = false

  cluster_name         = each.value.name
  project              = each.value.project
  num_projects         = 10
  num_namespaces       = 12
  num_secrets          = 100
  num_users            = 300
  name_prefix          = "baseline-${each.value.id}"
  user_project_binding = true
  user_password        = "Ranchertest1234!"

  depends_on = [
    rancher2_cluster_sync.cluster_v1,
    rancher2_cluster_sync.cluster_v2
  ]
}
