module "linode_cloud_credential" {
  source         = "../../rancher-cloud-credential"
  create_new     = true
  name           = "${local.rancher_subdomain}-${random_pet.this.id}"
  cloud_provider = "linode"
  credential_config = {
    token = var.linode_token
  }
}

module "linode_node_template" {
  source                 = "../../rancher-node-template"
  create_new             = true
  name                   = "${local.rancher_subdomain}-${random_pet.this.id}-node-template"
  cloud_cred_id          = module.linode_cloud_credential.id
  install_docker_version = "20.10"
  cloud_provider         = "linode"
  node_config = {
    image         = var.image
    instance_type = var.node_instance_type
    region        = var.region
  }
}

resource "rancher2_node_pool" "this" {
  count            = 1
  cluster_id       = module.linode_cluster_v1.id
  name             = "${local.rancher_subdomain}-${random_pet.this.id}-${count.index}"
  hostname_prefix  = "${local.rancher_subdomain}-${random_pet.this.id}-pool${count.index}-node"
  node_template_id = module.linode_node_template.id
  quantity         = 1
  control_plane    = true
  etcd             = true
  worker           = true
}

module "linode_cluster_v1" {
  source      = "../../rancher-cluster/v1"
  name        = "${local.rancher_subdomain}-${random_pet.this.id}-cluster"
  description = "TF linode nodedriver cluster"
  labels = {
    distribution = var.k8s_distribution,
    cloud        = "linode"
  }
  k8s_distribution = var.k8s_distribution
  k8s_version      = var.k8s_version
  ### In order to setup the linode custom cloud provider you may follow the linode documentation here: https://www.linode.com/docs/guides/how-to-deploy-kubernetes-on-linode-with-rancher-2-x/
  # cloud_provider = custom
  network_config = {
    plugin = "canal"
    mtu    = null
  }
  upgrade_strategy = {
    drain = false
  }

  depends_on = [
    module.linode_node_template
  ]
}

resource "rancher2_cluster_sync" "this" {
  cluster_id    = module.linode_cluster_v1.id
  node_pool_ids = rancher2_node_pool.this[*].id
  state_confirm = 5

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

module "secret" {
  source      = "../../rancher-secret"
  name_prefix = "linode-secret"
  cluster_id  = rancher2_cluster_sync.this.id
  data = {
    example_secret = "True"
  }
}
