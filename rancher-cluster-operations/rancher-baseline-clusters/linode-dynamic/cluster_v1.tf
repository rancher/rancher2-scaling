module "node_template" {
  for_each = local.v1_configs
  source   = "../../rancher-node-template"
  providers = {
    rancher2 = rancher2
  }

  create_new             = var.create_node_reqs
  name                   = "${each.value.name}${each.key}-nt"
  cloud_cred_id          = module.cloud_credential.id
  install_docker_version = var.install_docker_version
  cloud_provider         = "linode"
  node_config = {
    image            = var.image
    instance_type    = var.server_instance_type
    region           = var.region
    authorized_users = var.authorized_users
    tags             = "RancherScaling:${local.rancher_subdomain},Owner:${local.rancher_subdomain}"
  }
  engine_fields = var.node_template_engine_fields
}

resource "rancher2_node_pool" "cluster_v1_np" {
  for_each = {
    for pool in local.v1_pools : "${pool.config_key}.${pool.pool_key}" => pool
  }
  cluster_id                  = module.cluster_v1[each.value.config_key].id
  name                        = each.value.name
  hostname_prefix             = each.value.hostname_prefix
  node_template_id            = module.node_template[each.value.config_key].id
  quantity                    = try(tonumber(each.value["quantity"]), false)
  control_plane               = try(tobool(each.value["control-plane"]), false)
  etcd                        = try(tobool(each.value["etcd"]), false)
  worker                      = try(tobool(each.value["worker"]), false)
  delete_not_ready_after_secs = var.auto_replace_timeout
}

module "cluster_v1" {
  for_each = local.v1_configs
  source   = "../../rancher-cluster/v1"
  providers = {
    rancher2 = rancher2
  }

  name               = each.value.name
  description        = "TF linode nodedriver cluster ${each.value.name}"
  k8s_distribution   = each.value.k8s_distribution
  k8s_version        = each.value.k8s_version
  network_config     = local.network_config
  upgrade_strategy   = local.upgrade_strategy
  kube_api           = local.kube_api
  agent_env_vars     = var.agent_env_vars
  enable_cri_dockerd = var.enable_cri_dockerd

  depends_on = [
    module.node_template
  ]
}

resource "rancher2_cluster_sync" "cluster_v1" {
  count         = local.v1_count
  cluster_id    = local.v1_clusters[count.index].id
  node_pool_ids = values(rancher2_node_pool.cluster_v1_np)[*].id
  state_confirm = 3
}

resource "local_file" "v1_kube_config" {
  count           = length(local.v1_kube_config_list)
  content         = local.v1_kube_config_list[count.index]
  filename        = "${path.module}/files/kube_config/${terraform.workspace}_${local.v1_clusters[count.index].name}_kube_config"
  file_permission = "0700"
}
