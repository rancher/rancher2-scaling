terraform {
  required_version = ">= 0.13"
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
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

locals {
  name_max_length    = 60
  rancher_subdomain  = split(".", split("//", "${var.rancher_api_url}")[1])[0]
  name_suffix        = length(var.name_suffix) > 0 ? var.name_suffix : "${terraform.workspace}"
  cloud_cred_name    = length(var.cloud_cred_name) > 0 ? var.cloud_cred_name : "${local.rancher_subdomain}-cloud-cred-${local.name_suffix}"
  node_template_name = length(var.node_template_name) > 0 ? var.node_template_name : "${local.rancher_subdomain}-nt-${local.name_suffix}"
  node_pool_name     = substr("${local.rancher_subdomain}-nt${local.name_suffix}", 0, local.name_max_length)
  cluster_name       = length(var.cluster_name) > 0 ? var.cluster_name : "${substr("${local.rancher_subdomain}-${local.name_suffix}", 0, local.name_max_length)}"
  node_pool_count    = length(var.roles_per_pool)
  network_config = {
    plugin = "canal"
    mtu    = null
  }
  upgrade_strategy = {
    drain = false
  }
}

module "cloud_credential" {
  source         = "../../rancher-cluster-operations/rancher-cloud-credential"
  create_new     = var.create_node_reqs
  name           = local.cloud_cred_name
  cloud_provider = "linode"
  credential_config = {
    token = var.linode_token
  }
}

module "node_template" {
  count                  = 3
  source                 = "../../rancher-cluster-operations/rancher-node-template"
  create_new             = var.create_node_reqs
  name                   = "${local.node_template_name}${count.index}"
  cloud_cred_id          = module.cloud_credential.id
  install_docker_version = var.install_docker_version
  cloud_provider         = "linode"
  node_config = {
    image            = var.image
    instance_type    = var.server_instance_type
    region           = var.region
    authorized_users = var.authorized_users
  }
}

resource "rancher2_node_pool" "np" {
  count                       = local.node_pool_count
  cluster_id                  = module.cluster_v1[*].id
  name                        = "${local.node_pool_name}-${count.index}"
  hostname_prefix             = "${local.node_pool_name}-pool${count.index}-node"
  node_template_id            = module.node_template[*].id
  quantity                    = try(tonumber(var.roles_per_pool[count.index]["quantity"]), false)
  control_plane               = try(tobool(var.roles_per_pool[count.index]["control-plane"]), false)
  etcd                        = try(tobool(var.roles_per_pool[count.index]["etcd"]), false)
  worker                      = try(tobool(var.roles_per_pool[count.index]["worker"]), false)
  delete_not_ready_after_secs = var.auto_replace_timeout
}

module "cluster_v1" {
  count            = 3
  source           = "../../rancher-cluster-operations/rancher-cluster/v1"
  name             = "${local.cluster_name}${count.index}"
  description      = "TF linode nodedriver cluster ${local.cluster_name}${count.index}"
  labels           = var.cluster_labels
  k8s_distribution = "rke1"
  k8s_version      = var.k8s_version
  network_config   = local.network_config
  upgrade_strategy = local.upgrade_strategy

  depends_on = [
    module.node_template
  ]
}

# module "bulk_components" {
#   source = "../../bulk-components"

#   for_each          = module.cluster_v1[*]
#   rancher_api_url   = var.rancher_api_url
#   rancher_token_key = var.rancher_token_key
#   # cluster_name = "ival-rke2-bulk-users"
#   output_local_file = false

#   num_projects          = 10
#   num_namespaces        = 12
#   num_secrets           = 1000
#   num_users             = 1000
#   user_name_ref_pattern = "baseline-bulk-user"
#   user_project_binding  = false
#   user_password         = "Ranchertest1234!"
# }

resource "rancher2_cluster_sync" "this" {
  cluster_id    = module.cluster_v1[*].id
  node_pool_ids = rancher2_node_pool.np[*].id
}

resource "local_file" "kube_config" {
  content  = nonsensitive(rancher2_cluster_sync.this.kube_config)
  filename = "${path.module}/files/kube_config/${terraform.workspace}_kube_config"
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

output "cluster_name" {
  value = local.cluster_name
}

# output "kube_config" {
#   value = nonsensitive(module.cluster_v1.kube_config)
# }
