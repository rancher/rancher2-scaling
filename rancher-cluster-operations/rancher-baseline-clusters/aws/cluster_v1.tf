module "node_template" {
  source = "../../rancher-node-template"
  providers = {
    rancher2 = rancher2
  }

  create_new             = var.create_node_reqs
  name                   = local.node_template_name
  cloud_cred_id          = module.cloud_credential.id
  install_docker_version = var.install_docker_version
  cloud_provider         = "aws"
  node_config = {
    ami                  = data.aws_ami.ubuntu.id
    ssh_user             = "ubuntu"
    instance_type        = var.server_instance_type
    region               = var.region
    security_group       = var.security_groups
    subnet_id            = local.instance_subnet_id
    vpc_id               = data.aws_vpc.default.id
    zone                 = local.selected_az_suffix
    root_size            = var.volume_size
    volume_type          = var.volume_type
    iam_instance_profile = var.iam_instance_profile
    tags                 = "RancherScaling,${local.rancher_subdomain},Owner,${local.rancher_subdomain}"
  }
  engine_fields = var.node_template_engine_fields
}

resource "rancher2_node_pool" "this" {
  cluster_id                  = module.rke1.id
  name                        = "rke1-pool0"
  hostname_prefix             = substr("${local.rancher_subdomain}-${local.name_suffix}-rke1-pool0-node", 0, local.name_max_length)
  node_template_id            = module.node_template.id
  quantity                    = try(tonumber(local.roles_per_pool[0]["quantity"]), false)
  control_plane               = try(tobool(local.roles_per_pool[0]["control-plane"]), false)
  etcd                        = try(tobool(local.roles_per_pool[0]["etcd"]), false)
  worker                      = try(tobool(local.roles_per_pool[0]["worker"]), false)
  delete_not_ready_after_secs = var.auto_replace_timeout
}

module "rke1" {
  source = "../../rancher-cluster/v1"
  providers = {
    rancher2 = rancher2
  }

  name               = "${local.cluster_name}-rke1"
  description        = "TF linode nodedriver cluster ${local.cluster_name}-rke1"
  k8s_distribution   = "rke1"
  k8s_version        = var.rke1_version
  network_config     = local.network_config
  upgrade_strategy   = local.upgrade_strategy
  kube_api           = local.kube_api
  agent_env_vars     = var.agent_env_vars
  enable_cri_dockerd = var.enable_cri_dockerd

  depends_on = [
    module.node_template
  ]
}

resource "rancher2_cluster_sync" "rke1" {
  cluster_id    = module.rke1.id
  node_pool_ids = [rancher2_node_pool.this.id]
  state_confirm = 3
}

resource "local_file" "rke1_kube_config" {
  content         = rancher2_cluster_sync.rke1.kube_config
  filename        = "${path.module}/files/kube_config/${module.rke1.name}_kube_config"
  file_permission = "0700"
}
