terraform {
  required_version = ">= 0.14"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    local = {
      source = "hashicorp/local"
    }
    random = {
      source = "hashicorp/random"
    }
    rancher2 = {
      source = "rancher/rancher2"
    }
    helm = {
      source = "hashicorp/helm"
    }
    linode = {
      source = "linode/linode"
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
  region                   = var.region
  s3_bucket_region         = length(var.s3_bucket_region) > 0 ? var.s3_bucket_region : local.region
  name                     = "${random_pet.identifier.id}-rke1"
  identifier               = random_pet.identifier.id
  domain                   = var.domain
  use_new_bootstrap        = length(regexall("^([2-9]|\\d{2,})\\.([6-9]|\\d{2,})\\.([0-9]|\\d{2,})", var.rancher_version)) > 0
  install_common           = var.install_rancher || var.install_certmanager
  install_monitoring       = local.install_common && var.install_monitoring && var.install_rancher
  server_node_count        = local.install_monitoring ? (var.node_count + 1) : var.node_count
  server_addresses         = var.infra_provider == "aws" ? slice(module.aws_infra[0].nodes_public_ips, 0, var.node_count) : slice(module.linode_infra[0].instances[*].ip_address, 0, var.node_count)
  server_private_addresses = var.infra_provider == "aws" ? slice(module.aws_infra[0].nodes_private_ips, 0, var.node_count) : slice(module.linode_infra[0].instances[*].private_ip_address, 0, var.node_count)
  monitor_address          = var.infra_provider == "aws" && local.install_monitoring ? slice(module.aws_infra[0].nodes_public_ips, var.node_count, var.node_count + 1)[0] : var.infra_provider == "linode" && local.install_monitoring ? slice(module.linode_infra[0].instances[*].ip_address, var.node_count, var.node_count + 1)[0] : null
  monitor_private_address  = var.infra_provider == "aws" && local.install_monitoring ? slice(module.aws_infra[0].nodes_private_ips, var.node_count, var.node_count + 1)[0] : var.infra_provider == "linode" && local.install_monitoring ? slice(module.linode_infra[0].instances[*].private_ip_address, var.node_count, var.node_count + 1)[0] : null
  rke_file_path            = "${path.module}/files/clusters/${terraform.workspace}"
  cluster_yml              = "${local.rke_file_path}/${terraform.workspace}_cluster.yml"
  kube_config              = "${local.rke_file_path}/kube_config_${terraform.workspace}_cluster.yml"
  rancher_url              = local.install_common ? try(module.install_common[0].rancher_url, "") : ""
  rancher_token            = local.install_common ? try(module.install_common[0].rancher_token, "") : ""
  nodes_info = var.infra_provider == "aws" ? [for i in range(0, local.server_node_count) : {
    id              = module.aws_infra[0].nodes_ids[i],
    public_address  = module.aws_infra[0].nodes_public_ips[i],
    private_address = module.aws_infra[0].nodes_private_ips[i]
    }] : [for i in range(0, local.server_node_count) : {
    id              = module.linode_infra[0].instances[i].id,
    public_address  = module.linode_infra[0].instances[i].ip_address,
    private_address = module.linode_infra[0].instances[i].private_ip_address
  }]
  system_images             = yamlencode(var.system_images)
  rke_metadata_config_index = length(var.rancher_settings) > 0 ? index(var.rancher_settings.*.name, "rke-metadata-config") : null
  rke_metadata_url          = try(local.rke_metadata_config_index >= 0 ? var.rancher_settings[local.rke_metadata_config_index].value.url : "", "")
  rke_command               = length(local.rke_metadata_url) > 0 ? "RANCHER_METADATA_URL=${local.rke_metadata_url} rke up --config ${local.cluster_yml}" : "rke up --config ${local.cluster_yml}"
}

resource "random_password" "rancher_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

module "aws_infra" {
  count  = var.infra_provider == "aws" ? 1 : 0
  source = "../control-plane/modules/aws-infra"
  providers = {
    aws = aws
  }

  vpc_id                 = data.aws_vpc.default[0].id
  create_external_nlb    = true
  name                   = local.name
  user                   = data.aws_caller_identity.current[0].user_id
  ssh_keys               = var.ssh_keys
  ssh_key_path           = var.ssh_key_path
  server_instance_type   = var.node_type
  server_node_count      = local.server_node_count
  install_docker_version = var.install_docker_version
  domain                 = local.domain
  r53_domain             = var.r53_domain
  s3_instance_profile    = var.s3_instance_profile
}

module "linode_infra" {
  count  = var.infra_provider == "linode" ? 1 : 0
  source = "../linode-infra"
  providers = {
    linode = linode
  }

  random_prefix   = var.random_prefix
  linode_token    = var.linode_token
  nlb             = true
  authorized_keys = var.ssh_keys
  subdomain       = local.name
  domain          = local.domain
  instance_type   = var.node_type
  node_count      = local.server_node_count
  image           = var.node_image
  root_pass       = var.rancher_password
  ssh_key_path    = var.ssh_key_path
  private_ip      = true
}

resource "aws_route53_record" "linode" {
  count   = var.infra_provider == "linode" ? 1 : 0
  zone_id = data.aws_route53_zone.linode[0].zone_id
  name    = "${local.name}.${local.domain}"
  type    = "CNAME"
  ttl     = 30
  records = [module.linode_infra[0].lb_hostname]
}

resource "local_file" "cluster_yml" {
  filename = local.cluster_yml
  content = templatefile("${path.module}/files/values/rke_cluster_yaml.tfpl", {
    addresses                 = local.server_addresses,
    private_addresses         = local.server_private_addresses,
    dedicated_monitoring      = local.install_monitoring,
    monitor_address           = local.monitor_address,
    monitor_private_address   = local.monitor_private_address,
    enable_secrets_encryption = var.enable_secrets_encryption,
    enable_audit_log          = var.enable_audit_log,
    ssh_key_path              = var.ssh_key_path,
    kubernetes_version        = var.install_k8s_version
    enable_cri_dockerd        = var.enable_cri_dockerd
    user                      = var.user
    system_images             = var.system_images
  })

  depends_on = [
    module.aws_infra,
    module.linode_infra
  ]
}

resource "null_resource" "rke" {
  triggers = {
    "rke_file_path"  = "${local.rke_file_path}/"
    "cluster_yml"    = local.cluster_yml
    "cluster_yml_id" = local_file.cluster_yml.id
    "kube_config"    = local.kube_config
  }
  provisioner "local-exec" {
    command = local.rke_command
  }
  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
    rke remove --force --config ${self.triggers.cluster_yml} && rm -rf ${self.triggers.rke_file_path}
    EOT
    environment = {
      rke_file_path = self.triggers.rke_file_path
      cluster_yml   = self.triggers.cluster_yml
      kube_config   = self.triggers.kube_config
    }
  }
  depends_on = [
    local_file.cluster_yml
  ]
}

module "install_common" {
  count  = local.install_common ? 1 : 0
  source = "../rancher-cluster-operations/install-common"
  providers = {
    rancher2 = rancher2.bootstrap
  }

  kube_config_path = data.local_file.kube_config.filename

  subdomain           = local.name
  domain              = local.domain
  install_certmanager = var.install_certmanager
  install_rancher     = var.install_rancher
  rancher_version     = var.rancher_version
  certmanager_version = var.certmanager_version

  helm_rancher_chart_values_path = "${path.module}/files/values/rancher_chart_values.tftpl"
  letsencrypt_email              = var.letsencrypt_email
  rancher_image                  = var.rancher_image
  rancher_image_tag              = var.rancher_image_tag
  rancher_password               = var.rancher_password
  use_new_bootstrap              = local.use_new_bootstrap
  rancher_node_count             = var.node_count
  rancher_env_vars               = var.rancher_env_vars
  rancher_additional_values      = var.rancher_additional_values
  cattle_prometheus_metrics      = var.cattle_prometheus_metrics
  byo_certs_bucket_path          = var.byo_certs_bucket_path

  depends_on = [
    null_resource.rke,
    data.local_file.kube_config
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
      KUBECONFIG = base64encode(data.local_file.kube_config.content)
    }
  }

  depends_on = [
    module.install_common
  ]
}

resource "rancher2_setting" "this" {
  count    = length(var.rancher_settings) > 0 ? length(var.rancher_settings) : 0
  provider = rancher2.admin

  name        = var.rancher_settings[count.index].name
  value       = var.rancher_settings[count.index].name == "rke-metadata-config" ? jsonencode(var.rancher_settings[count.index].value) : tostring(var.rancher_settings[count.index].value)
  annotations = try(var.rancher_settings[count.index].annotations, null)
  labels      = try(var.rancher_settings[count.index].labels, null)

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
    null_resource.set_loglevel,
    module.install_common
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
