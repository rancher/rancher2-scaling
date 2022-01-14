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
  name               = random_pet.identifier.id
  identifier         = random_pet.identifier.id
  domain             = var.domain
  db_multi_az        = false
  use_new_bootstrap  = length(regexall("^([2-9]|\\d{3,})\\.([6-9]|\\d{3,})\\.([0-9]|\\d{3,})(-rc\\d{2,})?$", var.rancher_version)) > 0
  install_monitoring = var.install_monitoring && var.install_rancher
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
  db_pass                     = var.db_password
  db_port                     = var.db_port
  db_name                     = var.db_name
  db_security_group           = aws_security_group.database[0].id
  k3s_datastore_endpoint      = module.db[0].db_instance_endpoint
  k3s_storage_engine          = var.db_engine
  ssh_keys                    = var.ssh_keys
  create_external_nlb         = false
  install_rancher             = var.install_rancher
  rancher_password            = var.rancher_password != null ? var.rancher_password : random_password.rancher_password.result
  rancher_image               = var.rancher_image
  rancher_image_tag           = var.rancher_image_tag
  server_instance_type        = var.rancher_instance_type
  server_node_count           = var.rancher_node_count
  install_k3s_version         = var.install_k3s_version
  server_k3s_exec             = var.server_k3s_exec
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
  server_node_count      = var.rancher_node_count
  install_docker_version = var.install_docker_version
  domain                 = local.domain
  r53_domain             = var.r53_domain
  s3_instance_profile    = var.s3_instance_profile
}

module "rke1" {
  count  = var.k8s_distribution == "rke1" ? 1 : 0
  source = "./modules/rke1"

  cluster_name           = "local"
  server_node_count      = var.rancher_node_count
  ssh_key_path           = var.ssh_key_path
  install_docker_version = var.install_docker_version
  install_k8s_version    = var.install_k8s_version
  s3_instance_profile    = var.s3_instance_profile
  nodes_ids              = module.aws_infra[0].nodes_ids
  nodes_public_ips       = module.aws_infra[0].nodes_public_ips
  nodes_private_ips      = module.aws_infra[0].nodes_private_ips

  depends_on = [
    module.aws_infra
  ]
}

module "generate_kube_config" {
  source = "./modules/generate-kube-config"

  kubeconfig_content = var.k8s_distribution == "rke1" ? module.rke1[0].kube_config : module.k3s[0].kube_config
  kubeconfig_dir     = "${path.module}/files/kube_config"
  identifier_prefix  = local.name
}

module "install_common" {
  count  = var.k8s_distribution == "rke1" ? 1 : 0
  source = "./modules/install-common"

  providers = {
    rancher2 = rancher2.bootstrap
  }

  kube_config_path       = module.generate_kube_config.kubeconfig_path
  cluster_host_url       = module.rke1[0].api_server_url
  client_certificate     = module.rke1[0].client_cert
  client_key             = module.rke1[0].client_key
  cluster_ca_certificate = module.rke1[0].ca_crt

  subdomain           = local.name
  domain              = local.domain
  install_certmanager = var.install_certmanager
  install_rancher     = var.install_rancher

  helm_rancher_chart_values_path = "${path.module}/files/values/rancher_chart_values.tftpl"
  letsencrypt_email              = var.letsencrypt_email
  rancher_image                  = var.rancher_image
  rancher_image_tag              = var.rancher_image_tag
  rancher_version                = var.rancher_version
  rancher_password               = var.rancher_password
  use_new_bootstrap              = local.use_new_bootstrap
  rancher_node_count             = var.rancher_node_count
  byo_certs_bucket_path          = var.byo_certs_bucket_path
  private_ca_file                = var.private_ca_file

  depends_on = [
    module.generate_kube_config
  ]
}

resource "rancher2_catalog_v2" "rancher_charts_custom" {
  count    = var.k8s_distribution == "rke1" && local.install_monitoring ? 1 : 0
  provider = rancher2.admin

  cluster_id = "local"
  name       = "rancher-charts-custom"
  git_repo   = length(var.rancher_charts_repo) > 0 ? var.rancher_charts_repo : "https://git.rancher.io/charts"
  git_branch = var.rancher_charts_branch

  depends_on = [
    module.install_common
  ]
}

resource "rancher2_app_v2" "rancher_monitoring" {
  count    = var.k8s_distribution == "rke1" && local.install_monitoring ? 1 : 0
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
