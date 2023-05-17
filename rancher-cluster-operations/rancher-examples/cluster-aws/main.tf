module "aws_cloud_credential" {
  source         = "../../rancher-cloud-credential"
  create_new     = true
  name           = "${local.rancher_subdomain}-${random_pet.this.id}"
  cloud_provider = "aws"
  credential_config = {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region     = var.region
  }
}

module "aws_node_template" {
  source                 = "../../rancher-node-template"
  create_new             = true
  name                   = "${local.rancher_subdomain}-${random_pet.this.id}-node-template"
  cloud_cred_id          = module.aws_cloud_credential.id
  install_docker_version = "20.10"
  cloud_provider         = "aws"
  node_config = {
    ami                  = data.aws_ami.ubuntu.id
    instance_type        = var.node_instance_type
    region               = var.region
    security_group       = var.security_groups
    subnet_id            = local.instance_subnet_id
    vpc_id               = data.aws_vpc.default.id
    zone                 = local.selected_az_suffix
    root_size            = "32"
    volume_type          = "gp2"
    iam_instance_profile = null
  }
}

resource "rancher2_node_pool" "this" {
  count            = 1
  cluster_id       = module.aws_cluster_v1.id
  name             = "${local.rancher_subdomain}-${random_pet.this.id}-${count.index}"
  hostname_prefix  = "${local.rancher_subdomain}-${random_pet.this.id}-pool${count.index}-node"
  node_template_id = module.aws_node_template.id
  quantity         = 1
  control_plane    = true
  etcd             = true
  worker           = true
}

module "aws_cluster_v1" {
  source      = "../../rancher-cluster/v1"
  name        = "${local.rancher_subdomain}-${random_pet.this.id}-cluster"
  description = "TF AWS nodedriver cluster"
  labels = {
    distribution = var.k8s_distribution,
    cloud        = "aws"
  }
  k8s_distribution = var.k8s_distribution
  k8s_version      = var.k8s_version
  ### Do NOT set cloud_provider here unless module.aws_node_template.iam_instance_profile is set to a valid value
  # cloud_provider   = "aws"
  network_config = {
    plugin = "canal"
    mtu    = null
  }
  upgrade_strategy = {
    drain = false
  }

  depends_on = [
    module.aws_node_template
  ]
}

resource "rancher2_cluster_sync" "this" {
  cluster_id    = module.aws_cluster_v1.id
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
  name_prefix = "aws-secret"
  cluster_id  = rancher2_cluster_sync.this.id
  data = {
    example_secret = "True"
  }
}
