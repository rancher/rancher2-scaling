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
  rancher_subdomain  = split(".", split("//", "${var.rancher_api_url}")[1])[0]
  name_suffix        = try("-${var.name_suffix}", "")
  cloud_cred_name    = "${local.rancher_subdomain}-linode-cloud-cred${local.name_suffix}"
  node_template_name = "${local.rancher_subdomain}-linode-nt${local.name_suffix}"
  node_pool_name     = "${local.cluster_name}-np${local.name_suffix}"
  cluster_name       = "${local.rancher_subdomain}-linode-${var.cluster_name}-${terraform.workspace}"

  network_config = {
    plugin = "canal"
    mut    = null
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
  source                 = "../../rancher-cluster-operations/rancher-node-template"
  create_new             = var.create_node_reqs
  name                   = local.node_template_name
  cloud_cred_id          = module.cloud_credential.id
  install_docker_version = var.install_docker_version
  cloud_provider         = "linode"
  node_config = {
    image         = var.image
    instance_type = var.server_instance_type
    region        = var.region
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
  description      = "TF linode nodedriver cluster ${local.cluster_name}"
  labels           = var.cluster_labels
  k8s_distribution = "rke1"
  k8s_version      = var.k8s_version
  network_config   = local.network_config
  upgrade_strategy = local.upgrade_strategy

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
