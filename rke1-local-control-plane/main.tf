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
  aws_region               = var.aws_region
  name                     = "${random_pet.identifier.id}-rke1"
  identifier               = random_pet.identifier.id
  domain                   = var.domain
  use_new_bootstrap        = length(regexall("^([2-9]|\\d{2,})\\.([6-9]|\\d{2,})\\.([0-9]|\\d{2,})", var.rancher_version)) > 0
  install_common           = var.install_rancher || var.install_certmanager
  install_monitoring       = local.install_common && var.install_monitoring && var.install_rancher
  server_node_count        = local.install_monitoring ? (var.rancher_node_count + 1) : var.rancher_node_count
  server_addresses         = slice(module.aws_infra.nodes_public_ips, 0, var.rancher_node_count)
  server_private_addresses = slice(module.aws_infra.nodes_private_ips, 0, var.rancher_node_count)
  monitor_address          = local.install_monitoring ? slice(module.aws_infra.nodes_public_ips, var.rancher_node_count, var.rancher_node_count + 1)[0] : null
  monitor_private_address  = local.install_monitoring ? slice(module.aws_infra.nodes_private_ips, var.rancher_node_count, var.rancher_node_count + 1)[0] : null
  rke_file_path            = "${path.module}/files/clusters"
  cluster_yml              = "${local.rke_file_path}/${terraform.workspace}_cluster.yml"
  kube_config              = "${local.rke_file_path}/kube_config_${terraform.workspace}_cluster.yml"
  rancher_url              = local.install_monitoring ? module.install_common[0].rancher_url : ""
  rancher_token            = local.install_monitoring ? module.install_common[0].rancher_token : ""
  nodes_info = [for i in range(0, local.server_node_count) : {
    id              = module.aws_infra.nodes_ids[i],
    public_address  = module.aws_infra.nodes_public_ips[i],
    private_address = module.aws_infra.nodes_private_ips[i]
  }]

}

resource "random_password" "rancher_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

module "aws_infra" {
  source = "../control-plane/modules/aws-infra"

  vpc_id                 = data.aws_vpc.default.id
  create_external_nlb    = true
  name                   = local.name
  user                   = data.aws_caller_identity.current.user_id
  ssh_keys               = var.ssh_keys
  ssh_key_path           = var.ssh_key_path
  server_instance_type   = var.rancher_instance_type
  server_node_count      = local.server_node_count
  install_docker_version = var.install_docker_version
  domain                 = local.domain
  r53_domain             = var.r53_domain
  s3_instance_profile    = var.s3_instance_profile
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
  })

  depends_on = [
    module.aws_infra
  ]
}

resource "null_resource" "rke" {
  triggers = {
    "rke_file_path" = local.rke_file_path
    "cluster_yml"   = local.cluster_yml
    "kube_config"   = local.kube_config
  }
  provisioner "local-exec" {
    command = "rke up --config ${local.cluster_yml}"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "rke remove --force --config ${self.triggers.cluster_yml}; rm -rf ${self.triggers.rke_file_path}"
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
  rancher_node_count             = var.rancher_node_count
  cattle_prometheus_metrics      = var.cattle_prometheus_metrics

  depends_on = [
    null_resource.rke
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
      KUBECONFIG = base64encode(file(data.local_file.kube_config.content))
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
    # null_resource.set_loglevel
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
