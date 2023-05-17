terraform {
  required_version = ">= 0.13"
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
    }
  }
}

resource "rancher2_cluster" "this" {
  name        = var.name
  description = try(var.description, null)
  labels      = try(var.labels, null)
  annotations = try(var.annotations, null)
  dynamic "agent_env_vars" {
    for_each = var.agent_env_vars != null ? var.agent_env_vars : []
    iterator = env_var
    content {
      name  = env_var.value.name
      value = env_var.value.value
    }
  }

  # If provisioning OR importing RKE1 cluster(s) use the following
  dynamic "rke_config" {
    for_each = var.k8s_distribution == "rke1" ? [1] : []

    content {
      kubernetes_version    = var.k8s_version
      ignore_docker_version = false
      addons_include        = var.addons_include
      addons                = var.addons
      addon_job_timeout     = 60
      enable_cri_dockerd    = var.enable_cri_dockerd

      dynamic "cloud_provider" {
        for_each = var.cloud_provider != null ? [1] : []
        content {
          name                  = var.cloud_provider
          custom_cloud_provider = var.cloud_provider == "custom" ? var.cloud_config : null
        }
      }
      dynamic "network" {
        for_each = var.network_config != null ? [1] : []
        content {
          # calico_network_provider {
          #   cloud_provider = try(var.network_config.calico_network_provider, null)
          # }
          # flannel_network_provider {
          #   iface = try(var.network_config.flannel_network_provider, null)
          # }
          # canal_network_provider {
          #   iface = try(var.network_config.canal_network_provider, null)
          # }
          # weave_network_provider {
          #   password = try(var.network_config.weave_network_provider, null)
          # }
          mtu     = try(var.network_config.mtu, null)
          options = try(var.network_config.options, null)
          plugin  = try(var.network_config.plugin, null)
          dynamic "tolerations" {
            for_each = try(var.network_config.tolerations != null, false) ? [var.network_config.tolerations] : []
            iterator = toleration
            content {
              key      = try(toleration.key, null)
              effect   = try(toleration.effect, null)
              operator = try(toleration.operator, null)
              seconds  = try(toleration.seconds, null)
              value    = try(toleration.value, null)
            }
          }
        }
      }
      services {
        dynamic "kube_api" {
          for_each = var.kube_api != null ? [var.kube_api] : []
          iterator = item
          content {
            admission_configuration = try(item.value.admission_configuration, null)
            always_pull_images      = try(item.value.always_pull_images, null)
            # audit_log {
            #   enabled       = try(item.value.audit_log.enabled, null)
            #   configuration = try(item.value.audit_log.configuration, null)
            # }
            # event_rate_limit {
            #   enabled       = try(item.value.event_rate_limit.enabled, null)
            #   configuration = try(item.value.event_rate_limit.configuration, null)
            # }
            extra_args          = try(item.value.extra_args, null)
            extra_binds         = try(item.value.extra_binds, null)
            extra_env           = try(item.value.extra_env, null)
            image               = try(item.value.image, null)
            pod_security_policy = try(item.value.pod_security_policy, null)
            dynamic "secrets_encryption_config" {
              for_each = try(item.value.secrets_encryption_config != null, false) ? [item.value.secrets_encryption_config] : []
              content {
                enabled       = try(secrets_encryption_config.enabled, null)
                custom_config = try(secrets_encryption_config.custom_config, null)
              }
            }
            service_cluster_ip_range = try(item.value.service_cluster_ip_range, null)
            service_node_port_range  = try(item.value.service_node_port_range, null)
          }
        }
        dynamic "kubelet" {
          for_each = var.kubelet != null ? [var.kubelet] : []
          iterator = item
          content {
            cluster_dns_server           = try(item.value.cluster_dns_server, null)
            cluster_domain               = try(item.value.cluster_domain, null)
            extra_args                   = try(item.value.extra_args, null)
            extra_binds                  = try(item.value.extra_binds, null)
            extra_env                    = try(item.value.extra_env, null)
            fail_swap_on                 = try(item.value.fail_swap_on, null)
            generate_serving_certificate = try(item.value.generate_serving_certificate, null)
            image                        = try(item.value.image, null)
            infra_container_image        = try(item.value.infra_container_image, null)
          }
        }
        dynamic "kube_controller" {
          for_each = var.kube_controller != null ? [var.kube_controller] : []
          iterator = item
          content {
            cluster_cidr             = try(item.value.cluster_cidr, null)
            extra_args               = try(item.value.extra_args, null)
            extra_binds              = try(item.value.extra_binds, null)
            extra_env                = try(item.value.extra_env, null)
            image                    = try(item.value.image, null)
            service_cluster_ip_range = try(item.value.service_cluster_ip_range, null)
          }
        }
      }
      dynamic "upgrade_strategy" {
        for_each = var.upgrade_strategy != null ? [var.upgrade_strategy] : []
        iterator = item
        content {
          drain = try(item.value.drain, null)
          drain_input {
            delete_local_data  = try(item.value.drain_input.delete_local_data, null)
            force              = try(item.value.drain_input.force, null)
            grace_period       = try(item.value.drain_input.grace_period, null)
            ignore_daemon_sets = try(item.value.drain_input.ignore_daemon_sets, null)
            timeout            = try(item.value.drain_input.timeout, null)
          }
          max_unavailable_controlplane = try(item.value.max_unavailable_controlplane, null)
          max_unavailable_worker       = try(item.value.max_unavailable_worker, null)
        }
      }
    }
  }
  # If importing RKE2 cluster(s) use the following
  dynamic "rke2_config" {
    for_each = var.k8s_distribution == "rke2" ? [1] : []
    content {
      version = var.k8s_version
      dynamic "upgrade_strategy" {
        for_each = var.upgrade_strategy != null ? [var.upgrade_strategy] : []
        iterator = item
        content {
          drain_server_nodes = try(item.value.drain_server_nodes, null)
          drain_worker_nodes = try(item.value.drain_worker_nodes, null)
          server_concurrency = try(item.value.server_concurrency, null)
          worker_concurrency = try(item.value.worker_concurrency, null)
        }
      }
    }
  }

  # If importing K3s cluster(s) use the following
  dynamic "k3s_config" {
    for_each = var.k8s_distribution == "k3s" ? [1] : []
    content {
      version = var.k8s_version
      dynamic "upgrade_strategy" {
        for_each = var.upgrade_strategy != null ? [var.upgrade_strategy] : []
        iterator = item
        content {
          drain_server_nodes = try(item.value.drain_server_nodes, null)
          drain_worker_nodes = try(item.value.drain_worker_nodes, null)
          server_concurrency = try(item.value.server_concurrency, null)
          worker_concurrency = try(item.value.worker_concurrency, null)
        }
      }
    }
  }

}

output "id" {
  value = rancher2_cluster.this.id
}

output "name" {
  value = rancher2_cluster.this.name
}

output "default_project_id" {
  value = rancher2_cluster.this.default_project_id
}

output "cluster_registration_token" {
  value = rancher2_cluster.this.cluster_registration_token
}

output "registration_command" {
  value = rancher2_cluster.this.cluster_registration_token[0].command
}

output "insecure_registration_command" {
  value = rancher2_cluster.this.cluster_registration_token[0].insecure_command
}

output "driver" {
  value = rancher2_cluster.this.driver
}

output "kube_config" {
  value     = var.sensitive_output ? rancher2_cluster.this.kube_config : nonsensitive(rancher2_cluster.this.kube_config)
  sensitive = true
}
