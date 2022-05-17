terraform {
  required_providers {
    rke = {
      source = "rancher/rke"
    }
    null = {
      source = "hashicorp/null"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

locals {
  s3_instance_profile = var.s3_instance_profile
  node_ids            = var.nodes_ids
  node_public_ips     = var.nodes_public_ips
  node_private_ips    = var.nodes_private_ips
  # if using a dedicated monitoring node then assign the last node in the list as the dedicated node
  server_node_count           = var.dedicated_monitoring_node ? length(local.node_ids) - 1 : length(local.node_ids)
  rancher_reserved_node_ids   = slice(local.node_ids, 0, local.server_node_count)
  rancher_node_public_ips     = slice(local.node_public_ips, 0, local.server_node_count)
  rancher_node_private_ips    = slice(local.node_private_ips, 0, local.server_node_count)
  monitoring_reserved_node_id = var.dedicated_monitoring_node ? var.nodes_ids[local.server_node_count] : null
  monitoring_node_public_ip   = var.dedicated_monitoring_node ? var.nodes_public_ips[local.server_node_count] : null
  monitoring_node_private_ip  = var.dedicated_monitoring_node ? var.nodes_private_ips[local.server_node_count] : null
  allowed_etcd_nodes          = [1, 3, 5]
}

resource "rke_cluster" "local" {
  cluster_name = var.cluster_name
  cloud_provider {
    name = "aws"
    aws_cloud_provider {}
  }
  ### Nodes Reserved for Rancher ###
  dynamic "nodes" {
    for_each = toset(local.rancher_reserved_node_ids)
    content {
      hostname_override = "${var.hostname_override_prefix}-RKE1-HA${index(local.rancher_reserved_node_ids, nodes.key)}"
      address           = local.rancher_node_public_ips[index(local.rancher_reserved_node_ids, nodes.key)]
      internal_address  = local.rancher_node_private_ips[index(local.rancher_reserved_node_ids, nodes.key)]
      user              = "ubuntu"
      role              = ["controlplane", "worker", "etcd"]
    }
  }
  ### Node Reserved for Monitoring ###
  dynamic "nodes" {
    for_each = var.dedicated_monitoring_node ? toset([1]) : toset([]) # used to enable dynamic creation for dedicated monitoring node
    content {
      hostname_override = "${var.hostname_override_prefix}-RKE1-Monitoring"
      address           = local.monitoring_node_public_ip
      internal_address  = local.monitoring_node_private_ip
      user              = "ubuntu"
      # if we have an invalid # of etcd nodes then add the etcd role to the dedicated monitoring node
      role = contains(local.allowed_etcd_nodes, length(local.rancher_reserved_node_ids)) ? ["worker"] : ["worker", "etcd"]
      taints {
        key    = "monitoring"
        value  = "yes"
        effect = "NoSchedule"
      }
      labels = {
        monitoring = "yes"
      }
    }
  }
  ssh_key_path          = var.ssh_key_path
  ignore_docker_version = false
  # Set kubernetes version to install: https://rancher.com/docs/rke/latest/en/upgrades/#listing-supported-kubernetes-versions
  # Check with -> rke config --list-version --all
  kubernetes_version = length(var.install_k8s_version) > 0 ? var.install_k8s_version : null
  # Etcd snapshots
  services {
    etcd {
      backup_config {
        interval_hours = 12
        retention      = 6
      }
      snapshot  = true
      creation  = "6h"
      retention = "24h"
    }
    kube_api {
      secrets_encryption_config {
        enabled = var.secrets_encryption
      }
    }
  }

  # Configure  network plug-ins
  # RKE provides the following network plug-ins that are deployed as add-ons: flannel, calico, weave, and canal
  # After you launch the cluster, you cannot change your network provider.
  # Setting the network plug-in
  # network {
  #   plugin = "canal"
  #   options = {
  #     "canal_flannel_backend_type" = "vxlan"
  #   }
  # }

  # Specify DNS provider (coredns or kube-dns)
  # dns {
  #   provider = "coredns"
  # }

  # Currently, only authentication strategy supported is x509.
  # You can optionally create additional SANs (hostnames or IPs) to
  # add to the API server PKI certificate.
  # This is useful if you want to use a load balancer for the
  # control plane servers.
  # authentication {
  #   strategy = "x509"
  #   sans     = [local.rke1_tls_san]
  # }

  # Currently only nginx ingress provider is supported.
  # To disable ingress controller, set `provider: none`
  # `node_selector` controls ingress placement and is optional
  #   ingress {
  #     provider = "nginx"
  #     options = {
  #       "use-forwarded-headers" = "true"
  #     }
  #   }
}
