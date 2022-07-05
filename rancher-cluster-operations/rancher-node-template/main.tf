terraform {
  required_version = ">= 1.1.0"
  required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
      version = ">= 1.10.0"
    }
  }
}

resource "rancher2_node_template" "this" {
  count               = var.create_new ? 1 : 0
  name                = var.name
  cloud_credential_id = var.cloud_cred_id
  engine_install_url  = "https://releases.rancher.com/install-docker/${var.install_docker_version}.sh"

  dynamic "amazonec2_config" {
    for_each = var.cloud_provider == "aws" ? [1] : []
    content {
      ami                        = try(var.node_config.ami, null)
      region                     = try(var.node_config.region, null)
      security_group             = try(var.node_config.security_group, null)
      subnet_id                  = try(var.node_config.subnet_id, null)
      vpc_id                     = try(var.node_config.vpc_id, null)
      zone                       = try(var.node_config.zone, null)
      block_duration_minutes     = try(var.node_config.block_duration_minutes, null)
      device_name                = try(var.node_config.device_name, null)
      encrypt_ebs_volume         = try(var.node_config.encrypt_ebs_volume, null)
      endpoint                   = try(var.node_config.endpoint, null)
      iam_instance_profile       = try(var.node_config.iam_instance_profile, null)
      insecure_transport         = try(var.node_config.insecure_transport, null)
      instance_type              = try(var.node_config.instance_type, null)
      keypair_name               = try(var.node_config.keypair_name, null)
      kms_key                    = try(var.node_config.kms_key, null)
      monitoring                 = try(var.node_config.monitoring, null)
      open_port                  = try(var.node_config.open_port, null)
      private_address_only       = try(var.node_config.private_address_only, null)
      request_spot_instance      = try(var.node_config.request_spot_instance, null)
      retries                    = try(var.node_config.retries, null)
      root_size                  = try(var.node_config.root_size, null)
      security_group_readonly    = try(var.node_config.security_group_readonly, null)
      session_token              = try(var.node_config.session_token, null)
      spot_price                 = try(var.node_config.spot_price, null)
      ssh_keypath                = try(var.node_config.ssh_keypath, null)
      ssh_user                   = try(var.node_config.ssh_user, null)
      tags                       = try(var.node_config.tags, null)
      use_ebs_optimized_instance = try(var.node_config.use_ebs_optimized_instance, null)
      use_private_address        = try(var.node_config.private_ip_address, null)
      userdata                   = try(var.node_config.userdata, null)
      volume_type                = try(var.node_config.volume_type, null)
    }
  }

  dynamic "linode_config" {
    for_each = var.cloud_provider == "linode" ? [1] : []
    content {
      authorized_users  = try(var.node_config.authorized_users, null)
      image             = try(var.node_config.image, null)
      instance_type     = try(var.node_config.instance_type, null)
      region            = try(var.node_config.region, null)
      create_private_ip = try(var.node_config.create_private_ip, null)
      docker_port       = try(var.node_config.docker_port, null)
      label             = try(var.node_config.label, null)
      root_pass         = try(var.node_config.root_pass, null)
      ssh_port          = try(var.node_config.ssh_port, null)
      ssh_user          = try(var.node_config.ssh_user, null)
      stackscript       = try(var.node_config.stackscript, null)
      stackscript_data  = try(var.node_config.stackscript_data, null)
      swap_size         = try(var.node_config.swap_size, null)
      tags              = try(var.node_config.tags, null)
      token             = try(var.node_config.token, null)
      ua_prefix         = try(var.node_config.ua_prefix, null)
    }
  }
}

### Only create a node_template if the caller has defined that a new node_template should be created
### else, look for an existing node_template with the given name
data "rancher2_node_template" "this" {
  name = var.create_new ? rancher2_node_template.this[0].name : var.name
}

output "id" {
  value = data.rancher2_node_template.this.id
}

output "name" {
  value = data.rancher2_node_template.this.name
}

output "node_template" {
  value = data.rancher2_node_template.this
}
