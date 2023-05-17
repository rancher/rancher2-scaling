resource "rancher2_machine_config_v2" "this" {
  for_each      = local.v2_configs
  generate_name = "${each.value.name}${each.key}-nt"
  linode_config {
    image            = var.image
    instance_type    = var.server_instance_type
    region           = var.region
    authorized_users = var.authorized_users
    tags             = "RancherScaling:${local.rancher_subdomain},Owner:${local.rancher_subdomain}"
  }
}

resource "rancher2_cluster_v2" "cluster_v2" {
  for_each                     = local.v2_configs
  name                         = each.value.name
  kubernetes_version           = each.value.k8s_version
  cloud_credential_secret_name = module.cloud_credential.id
  dynamic "agent_env_vars" {
    for_each = var.agent_env_vars == null ? [] : var.agent_env_vars
    iterator = agent_var
    content {
      name  = agent_var.value.name
      value = agent_var.value.value
    }
  }
  rke_config {
    dynamic "machine_pools" {
      for_each = each.value.roles_per_pool
      iterator = pool
      content {
        name                         = "${each.value.name}-${pool.key}"
        cloud_credential_secret_name = module.cloud_credential.id
        control_plane_role           = try(tobool(pool.value["control-plane"]), false)
        worker_role                  = try(tobool(pool.value["worker"]), false)
        etcd_role                    = try(tobool(pool.value["etcd"]), false)
        quantity                     = try(tonumber(pool.value["quantity"]), 1)

        machine_config {
          kind = rancher2_machine_config_v2.this[each.key].kind
          name = rancher2_machine_config_v2.this[each.key].name
        }
      }
    }
  }
  timeouts {
    create = "15m"
  }
  depends_on = [
    module.cloud_credential
  ]
}

resource "rancher2_cluster_sync" "cluster_v2" {
  count         = local.v2_count
  cluster_id    = local.v2_clusters[count.index].cluster_v1_id
  state_confirm = 3
}

resource "local_file" "v2_kube_config" {
  count           = length(local.v2_kube_config_list)
  content         = local.v2_kube_config_list[count.index]
  filename        = "${path.module}/files/kube_config/${terraform.workspace}_${local.v2_clusters[count.index].name}_kube_config"
  file_permission = "0700"
}
