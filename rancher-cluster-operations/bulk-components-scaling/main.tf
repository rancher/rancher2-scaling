terraform {
  required_version = ">= 0.14"
  required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
      version = "1.21.0"
    }
    local = {
      source = "hashicorp/local"
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
  backend "local" {
    path = "rancher.tfstate"
  }
}

locals {
  name_prefix         = "${terraform.workspace}-scale"
  cluster_name_prefix = length(var.cluster_name) > 0 ? var.cluster_name : "${local.name_prefix}-${var.k8s_distribution}"

  scale_rke2 = var.k8s_distribution == "rke2" ? 1 : 0
  scale_k3s  = var.k8s_distribution == "k3s" ? 1 : 0
  scale_rke  = var.k8s_distribution == "rke1" ? 1 : 0

  secrets-cluster         = local.scale_rke2 == 1 ? module.rke2-bulk-clusters[0].secrets-cluster : local.scale_rke == 1 ? "" : local.scale_k3s == 1 ? "" : null
  secretsv2-cluster       = local.scale_rke2 == 1 ? module.rke2-bulk-clusters[0].secretsv2-cluster : local.scale_rke == 1 ? "" : local.scale_k3s == 1 ? "" : null
  tokens-cluster          = local.scale_rke2 == 1 ? module.rke2-bulk-clusters[0].tokens-cluster : local.scale_rke == 1 ? "" : local.scale_k3s == 1 ? "" : null
  aws-cloud-creds-cluster = local.scale_rke2 == 1 ? module.rke2-bulk-clusters[0].aws-cloud-creds-cluster : local.scale_rke == 1 ? "" : local.scale_k3s == 1 ? "" : null
  projects-cluster        = local.scale_rke2 == 1 ? module.rke2-bulk-clusters[0].projects-cluster : local.scale_rke == 1 ? "" : local.scale_k3s == 1 ? "" : null
  users-cluster           = local.scale_rke2 == 1 ? module.rke2-bulk-clusters[0].users-cluster : local.scale_rke == 1 ? "" : local.scale_k3s == 1 ? "" : null

  clusters_map = local.scale_rke2 == 1 ? { for k, v in [module.rke2-bulk-clusters[0].clusters-map] : k => true if v == true } : null
  kube_configs = local.scale_rke2 == 1 ? module.rke2-bulk-clusters[0].kube_configs : {}
}

module "rke2-bulk-clusters" {
  source = "./rke2"
  count  = local.scale_rke2
  scale_clusters = {
    secrets            = var.scale_secrets
    secretsv2          = var.scale_secretsv2
    tokens             = var.scale_tokens
    aws-cloud-creds    = var.scale_aws_cloud_creds
    linode-cloud-creds = var.scale_linode_cloud_creds
    users              = var.scale_users
    projects           = var.scale_projects
  }

  cluster_name_prefix  = local.cluster_name_prefix
  k8s_version          = var.k8s_version
  aws_region           = var.aws_region
  aws_access_key       = var.aws_access_key
  aws_secret_key       = var.aws_secret_key
  iam_instance_profile = var.iam_instance_profile
  security_groups      = var.security_groups
  roles_per_pool       = var.roles_per_pool
  server_instance_type = var.server_instance_type
  volume_size          = var.volume_size
  volume_type          = var.volume_type
}

module "generate_kube_config" {
  source   = "../../control-plane/modules/generate-kube-config"
  for_each = local.kube_configs

  kubeconfig_content = each.value
  kubeconfig_dir     = "${path.module}/files/kube_config"
  identifier_prefix  = each.key
  depends_on = [
    module.rke2-bulk-clusters,
  ]
}
