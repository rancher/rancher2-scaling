resource "rancher2_machine_config_v2" "this" {
  count         = 2
  generate_name = "${local.node_template_name}${count.index}"
  linode_config {
    image            = var.image
    instance_type    = var.server_instance_type
    region           = var.region
    authorized_users = var.authorized_users
    tags             = "RancherScaling:${local.rancher_subdomain},Owner:${local.rancher_subdomain}"
  }
}

resource "rancher2_cluster_v2" "rke2" {
  name               = "${local.cluster_name}-rke2"
  kubernetes_version = var.rke2_version
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
      for_each = local.roles_per_pool
      iterator = pool
      content {
        name                         = "rke2-pool0"
        cloud_credential_secret_name = module.cloud_credential.id
        control_plane_role           = try(tobool(pool.value["control-plane"]), false)
        worker_role                  = try(tobool(pool.value["worker"]), false)
        etcd_role                    = try(tobool(pool.value["etcd"]), false)
        quantity                     = try(tonumber(pool.value["quantity"]), 1)

        machine_config {
          kind = rancher2_machine_config_v2.this[0].kind
          name = rancher2_machine_config_v2.this[0].name
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

resource "rancher2_cluster_v2" "k3s" {
  name               = "${local.cluster_name}-k3s"
  kubernetes_version = var.k3s_version

  rke_config {
    dynamic "machine_pools" {
      for_each = local.roles_per_pool
      iterator = pool
      content {
        name                         = "k3s-pool0"
        cloud_credential_secret_name = module.cloud_credential.id
        control_plane_role           = try(tobool(pool.value["control-plane"]), false)
        worker_role                  = try(tobool(pool.value["worker"]), false)
        etcd_role                    = try(tobool(pool.value["etcd"]), false)
        quantity                     = try(tonumber(pool.value["quantity"]), 1)
        machine_config {
          kind = rancher2_machine_config_v2.this[1].kind
          name = rancher2_machine_config_v2.this[1].name
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

resource "rancher2_cluster_sync" "rke2" {
  cluster_id    = rancher2_cluster_v2.rke2.cluster_v1_id
  state_confirm = 3
}

resource "rancher2_cluster_sync" "k3s" {
  cluster_id    = rancher2_cluster_v2.k3s.cluster_v1_id
  state_confirm = 3
}

resource "local_file" "rke2" {
  content         = rancher2_cluster_sync.rke2.kube_config
  filename        = "${path.module}/files/kube_config/${rancher2_cluster_v2.rke2.name}_kube_config"
  file_permission = "0700"
}

resource "local_file" "k3s" {
  content         = rancher2_cluster_sync.k3s.kube_config
  filename        = "${path.module}/files/kube_config/${rancher2_cluster_v2.k3s.name}_kube_config"
  file_permission = "0700"
}
