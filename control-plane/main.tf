terraform {
  required_version = ">= 0.14"
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
    }
    rke = {
      source = "rancher/rke"
    }
    aws = {
      source = "hashicorp/aws"
    }
    local = {
      source = "hashicorp/local"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  backend "local" {
    path = "rancher.tfstate"
  }
}

resource "random_pet" "identifier" {
  keepers = {
  }
  prefix = var.random_prefix
  length = 1

}

locals {
  aws_region         = var.aws_region
  name               = "${random_pet.identifier.id}-${var.k8s_distribution}"
  identifier         = random_pet.identifier.id
  domain             = var.domain
  use_new_bootstrap  = length(regexall("^([2-9]|\\d{2,})\\.([6-9]|\\d{2,})\\.([0-9]|\\d{2,})", var.rancher_version)) > 0
  install_common     = (var.k8s_distribution == "rke1" || var.k8s_distribution == "rke2") && (var.install_rancher || var.install_certmanager)
  install_monitoring = local.install_common && var.install_monitoring && var.install_rancher
  kubeconfig_content = var.k8s_distribution == "k3s" ? module.k3s[0].kube_config : var.k8s_distribution == "rke1" ? module.rke1[0].kube_config : var.k8s_distribution == "rke2" ? module.rke2[0].kube_config : null
  rancher_url        = var.k8s_distribution == "k3s" ? module.k3s[0].rancher_url : var.k8s_distribution == "rke1" || var.k8s_distribution == "rke2" ? try(module.install_common[0].rancher_url, "") : ""
  rancher_token      = var.k8s_distribution == "k3s" ? module.k3s[0].rancher_token : var.k8s_distribution == "rke1" || var.k8s_distribution == "rke2" ? try(module.install_common[0].rancher_token, "") : ""
}

resource "random_password" "rancher_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

module "k3s" {
  count  = var.k8s_distribution == "k3s" ? 1 : 0
  source = "./modules/aws-k3s"
  providers = {
    rancher2 = rancher2.bootstrap,
    aws      = aws
  }

  vpc_id                      = data.aws_vpc.default.id
  private_subnets_cidr_blocks = ["172.31.48.0/20", "172.31.0.0/20", "172.31.16.0/20", "172.31.32.0/20"]
  name                        = local.name
  user                        = data.aws_caller_identity.current.user_id
  db_user                     = var.db_username
  db_pass                     = module.db[0].db_instance_password
  db_port                     = var.db_port
  db_name                     = var.db_name
  db_engine                   = var.db_engine
  db_security_group           = aws_security_group.database[0].id
  k3s_datastore_endpoint      = module.db[0].db_instance_endpoint
  k3s_storage_engine          = var.db_engine
  ssh_keys                    = var.ssh_keys
  install_rancher             = var.install_rancher
  rancher_password            = var.rancher_password != null ? var.rancher_password : random_password.rancher_password.result
  rancher_image               = var.rancher_image
  rancher_image_tag           = var.rancher_image_tag
  server_instance_type        = var.rancher_instance_type
  agent_instance_type         = var.rancher_instance_type
  server_node_count           = var.rancher_node_count
  server_k3s_exec             = var.enable_secrets_encryption ? "--secrets-encryption ${var.server_k3s_exec}" : var.server_k3s_exec
  cattle_prometheus_metrics   = var.cattle_prometheus_metrics
  create_agent_nlb            = var.install_monitoring
  agent_node_count            = var.install_monitoring ? 1 : 0
  agent_k3s_exec              = var.install_monitoring ? "--node-label monitoring=yes --node-taint monitoring=yes:NoSchedule ${var.agent_k3s_exec}" : var.agent_k3s_exec
  install_k3s_version         = var.install_k3s_version
  rancher_version             = var.rancher_version
  use_new_bootstrap           = local.use_new_bootstrap
  monitoring_version          = var.monitoring_version
  domain                      = local.domain
  r53_domain                  = var.r53_domain
  letsencrypt_email           = var.letsencrypt_email
  rancher_chart               = var.rancher_chart
  rancher_chart_tag           = var.rancher_charts_branch
  install_certmanager         = var.install_certmanager
  certmanager_version         = var.certmanager_version
  byo_certs_bucket_path       = var.byo_certs_bucket_path
  s3_instance_profile         = var.s3_instance_profile
  s3_bucket_region            = var.s3_bucket_region
  private_ca_file             = var.private_ca_file
  tls_cert_file               = var.tls_cert_file
  tls_key_file                = var.tls_key_file
}

module "aws_infra" {
  count  = var.k8s_distribution == "rke1" ? 1 : 0
  source = "./modules/aws-infra"

  vpc_id                 = data.aws_vpc.default.id
  create_external_nlb    = true
  name                   = local.name
  user                   = data.aws_caller_identity.current.user_id
  ssh_keys               = var.ssh_keys
  ssh_key_path           = var.ssh_key_path
  server_instance_type   = var.rancher_instance_type
  server_node_count      = local.install_monitoring ? (var.rancher_node_count + 1) : var.rancher_node_count
  install_docker_version = var.install_docker_version
  domain                 = local.domain
  r53_domain             = var.r53_domain
  s3_instance_profile    = var.s3_instance_profile
}

module "rke1" {
  count  = var.k8s_distribution == "rke1" ? 1 : 0
  source = "./modules/rke1"

  cluster_name = "local"
  # cloud_provider_name       = "aws"
  hostname_override_prefix  = local.name
  ssh_key_path              = var.ssh_key_path
  install_k8s_version       = var.install_k8s_version
  enable_cri_dockerd        = var.enable_cri_dockerd
  s3_instance_profile       = var.s3_instance_profile
  dedicated_monitoring_node = var.install_monitoring ? true : false
  nodes_ids                 = module.aws_infra[0].nodes_ids
  nodes_public_ips          = module.aws_infra[0].nodes_public_ips
  nodes_private_ips         = module.aws_infra[0].nodes_private_ips
  secrets_encryption        = var.enable_secrets_encryption

  depends_on = [
    module.aws_infra
  ]
}

module "rke2" {
  count  = var.k8s_distribution == "rke2" ? 1 : 0
  source = "./modules/rke2"

  name                   = local.name
  internal_lb            = false
  subdomain              = local.name
  domain                 = var.domain
  rke2_version           = var.install_rke2_version
  rke2_channel           = var.install_rke2_channel
  rke2_config            = var.rke2_config
  server_node_count      = var.rancher_node_count
  server_instance_type   = var.rancher_instance_type
  vpc_id                 = data.aws_vpc.default.id
  subnets                = data.aws_subnets.all.ids
  iam_instance_profile   = var.s3_instance_profile
  ssh_keys               = var.ssh_keys
  ssh_key_path           = var.ssh_key_path
  user                   = data.aws_caller_identity.current.user_id
  setup_monitoring_agent = local.install_monitoring
}

module "generate_kube_config" {
  source = "./modules/generate-kube-config"

  kubeconfig_content = local.kubeconfig_content
  kubeconfig_dir     = "${path.module}/files/kube_config"
  identifier_prefix  = local.name
  depends_on = [
    module.k3s,
    module.rke1,
    module.rke2
  ]
}

module "install_common" {
  count  = local.install_common ? 1 : 0
  source = "../rancher-cluster-operations/install-common"
  providers = {
    rancher2 = rancher2.bootstrap
  }

  kube_config_path = module.generate_kube_config.kubeconfig_path

  subdomain           = local.name
  domain              = local.domain
  install_certmanager = var.install_certmanager
  install_rancher     = var.install_rancher
  rancher_version     = var.rancher_version
  certmanager_version = var.certmanager_version

  letsencrypt_email         = var.letsencrypt_email
  rancher_image             = var.rancher_image
  rancher_image_tag         = var.rancher_image_tag
  rancher_password          = var.rancher_password
  use_new_bootstrap         = local.use_new_bootstrap
  rancher_node_count        = var.rancher_node_count
  byo_certs_bucket_path     = var.byo_certs_bucket_path
  private_ca_file           = var.private_ca_file
  cattle_prometheus_metrics = var.cattle_prometheus_metrics

  depends_on = [
    module.generate_kube_config
  ]
}

resource "null_resource" "set_loglevel" {
  count = var.install_rancher && var.rancher_loglevel != "info" ? 1 : 0
  provisioner "local-exec" {
    interpreter = [
      "bash", "-c"
    ]
    command = <<-EOT
    kubectl --kubeconfig <(echo $KUBECONFIG | base64 --decode) -n cattle-system get pods -l app=rancher --no-headers -o custom-columns=name:.metadata.name | while read rancherpod; do kubectl --kubeconfig <(echo $KUBECONFIG | base64 --decode) -n cattle-system exec $rancherpod -c rancher -- loglevel --set ${var.rancher_loglevel}; done
    EOT
    environment = {
      KUBECONFIG = base64encode(file(module.generate_kube_config.kubeconfig_path))
    }
  }

  depends_on = [
    module.install_common
  ]
}

resource "rancher2_catalog_v2" "rancher_charts_custom" {
  count    = local.install_monitoring ? 1 : 0
  provider = rancher2.admin

  cluster_id = "local"
  name       = "rancher-charts-custom"
  git_repo   = var.rancher_charts_repo
  git_branch = var.rancher_charts_branch

  provisioner "local-exec" {
    command = <<-EOT
    sleep 10
    EOT
  }

  depends_on = [
    null_resource.set_loglevel
  ]
}

resource "rancher2_app_v2" "rancher_monitoring" {
  count    = local.install_monitoring ? 1 : 0
  provider = rancher2.admin

  cluster_id    = "local"
  name          = "rancher-monitoring"
  namespace     = "cattle-monitoring-system"
  repo_name     = "rancher-charts-custom"
  chart_name    = "rancher-monitoring"
  chart_version = var.monitoring_version
  values        = file(var.monitoring_chart_values_path)

  depends_on = [
    rancher2_catalog_v2.rancher_charts_custom
  ]
}
