terraform {
  required_version = ">= 1.0"
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
    }
    aws = {
      source = "hashicorp/aws"
    }
    cloudinit = {
      source = "hashicorp/cloudinit"
    }
  }
}

terraform {
  backend "local" {
    path = "rancher.tfstate"
  }
}

locals {
  aws_region       = "us-west-1"
  cluster_instance = terraform.workspace
  insecure_flag    = var.insecure_flag

  rancher_subdomain = split(".", split("//", "${var.rancher_api_url}")[1])[0]
  name_max_length   = 60
  name_suffix       = length(var.name_suffix) > 0 ? var.name_suffix : "${terraform.workspace}"
  node_pool_name    = substr("${local.rancher_subdomain}-nt${local.name_suffix}", 0, local.name_max_length)
  cluster_name      = length(var.cluster_name) > 0 ? var.cluster_name : "${substr("${local.rancher_subdomain}-${local.name_suffix}", 0, local.name_max_length)}"
  node_pool_count   = length(var.roles_per_pool)
  num_nodes         = sum([for x in var.roles_per_pool[*].quantity : x])
  node_public_ips   = flatten(module.aws_infra[*].nodes_public_ips)
  kube_api = var.kube_api_debugging ? {
    extra_args = {
      v = "3"
    }
  } : null
}

provider "aws" {
  region  = local.aws_region
  profile = "rancher-eng"
}

provider "rancher2" {
  api_url   = var.rancher_api_url
  token_key = var.rancher_token_key
  insecure  = local.insecure_flag
}

module "cluster_v1" {
  source           = "../../rancher-cluster-operations/rancher-cluster/v1"
  name             = local.cluster_name
  description      = "TF aws nodedriver cluster ${local.cluster_name}"
  labels           = var.cluster_labels
  k8s_distribution = "rke1"
  network_config = {
    plugin = "canal"
    mtu    = null
  }
  upgrade_strategy = {
    drain = false
  }
  kube_api           = local.kube_api
  agent_env_vars     = var.agent_env_vars
  enable_cri_dockerd = var.enable_cri_dockerd

}

module "aws_infra" {
  source = "../../control-plane/modules/aws-infra"
  count  = length(var.roles_per_pool)

  vpc_id                        = data.aws_vpc.default.id
  use_route53                   = false
  create_external_nlb           = false
  create_internal_nlb           = false
  create_rancher_security_group = false
  extra_security_groups         = ["open-all"]
  name                          = local.cluster_name
  user                          = data.aws_caller_identity.current.user_id
  ssh_keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCQ7tGFQ82ky7piQbijUY90RMlNOhTsTAmev8ViAcT0cImGoAyRgcucqHfWuKYgtrkr7TfO7hCuOXW306eK+Eb2YfhWgTAw9eyJ/4o9DSeknBSbv9OSykDJWXCnupCVJiIRI3BXZpypTJQ+10oMEZQcniFmX511z/GMVp/+wI0Omgh/dK5gYDMOBd+SYKHH5OWeO2HQpfeMZQoJ+TpYYcGWhhF8GzK96fyeYQzVwHKOcz4zSQWa2z3PHcNyk8ZHkHB5dHyd5dOQQS4MvTzHjSiNcr1zZM1dI8RUP13Xdn29PuEmSrsZGE6NFIDPTeQ1dIoC4jCKUyoWgCaqTxJLqzY/",
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCI3qLxa0WSn4SaqZY8v6KPPdhb/LyrPfYFdtJVsvjvGOt7fN7tHl01sT/EeYVLmHFv51JFfGgaU9ceME7WY18CFvcTgqtfrUxOK3zuVUm9BrRdnVg9kZJHv5KDcApd5tZZ4aOUYtWw+rIN1/KYQFJ5naT1rY4erT6nde/ZSAbeh0cf6j7Sx/DTUUKPPvXGuS0k7K/ShrsD7RovAYHUkqHX4>",
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQClkPklRSgRSg94fqywLbBb6U/DB7kN2Pkh8F5uG9d8JPDmPcsGqNad6qVU90hmT0pR3hLSyARrOBEuUgRDK8GXL/LAQhEXgP/3/sTy9HgrOp6SyO+IKlsSoBsm7Z+4WILNq3m+93nxfxwjDrEz60N/a8lkweCgyUMCpmqk8HXtOlz72m4hjTWa1gCTVJq7gaNttrhEWOSwKFMPHgl4V46T6waZnN0KCXu5TynBk717lfsdwbiGnU9YuSKd3PfKksEp8rlNWT1HibkIEFwmM9m+m8TLJBVFA19CM+GfBzAYAam+QBvF7P0H52BXmZzYfIOLEs1NP13MjfoMRqLqcgkF",
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDrKlzEmwSvv6vE3ohcuHLfXKt0uhNb/AEMNc69rgYxpJBhBPG4vOEkbEJwEsbVpu3O4lPM/OaWkkm/ho73bLeFJ8p65Virw4SgEElQx4B8aNAfbidh74qDv4SyOrDr3YkPsOCj1F51kD1oHe9SaPFidDazj23xnI0nPGgfSs6Jzy7LfiAiIqCZGNYGMrIJ5M3wLIJXJ2KyNrcflD2pPxNy2OhR3XKSK12T9S75cz+t0CjxZcj6d90eLaBLjTV5bjaK5D0AISG8dZ+awTI8Czex+D70M6/spX+uLYNYF9AG2mXNsX1UBrCDz/1G5lSf4r5R3Mr8sQDrd00uuImgSJJ4KJShbhpud8hkfMDXVa723F+TbHwazklsw1ZOgqJo+mohaNV7gxNPOXkYNV42zibXq1cge95DnqvBqDqFB4vsfg3antKderEcGQsEE27enQEK3K0xlPOFiQeXCs1ywC8hBNJsZs1bI7wJnKJ091PUSofAL5OIgW2vhHzaMmbnC50+PtCHnP/pbFb2vyiqchll5fjQph4nWvs3HH8gDDSpsmLuTlR+leEAhs+zdhGsP11XXnRemmLe0+stXkOKvb/lhQ27rmrmda7ssRLwE1xxnZYU4O4/0TioFd2t12+KXo9a1l0jSofMxeuemWScIACbLoz4dlrtIDvEusLNv5KAUQ== bmdepesa@MacBook-Pro.tempe.rancherlabs.com",
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCI3qLxa0WSn4SaqZY8v6KPPdhb/LyrPfYFdtJVsvjvGOt7fN7tHl01sT/EeYVLmHFv51JFfGgaU9ceME7WY18CFvcTgqtfrUxOK3zuVUm9BrRdnVg9kZJHv5KDcApd5tZZ4aOUYtWw+rIN1/KYQFJ5naT1rY4erT6nde/ZSAbeh0cf6j7Sx/DTUUKPPvXGuS0k7K/ShrsD7RovAYHUkqHX4lAv+qa/vcbQWILu62B>",
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILi44P699pajgfra7lV0AYHCMPJkskVY3f8pxxe2Vo+w daniel.newman@suse.com",
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzuRYu9hswdR+Zj4iENEY3A+e/uXAMEZwHTLqH0mYUbQO5EOtR5DYQroGU7bNnYAn3E/vVc04W/2Lo5apuwARruBvk2/Ic8PEVibusXIehvfsH1hYP7BetvZwrQ7AUyi3nCbL6BggcVqlVQIE5D3bKjRnK8Fp4/11vfQJfYz2FrOwQhuuUMKdkcnM0CBn9bvn1xW0NVtoi1PuFh7gi1uWRrNfRRlD+Vg/2iCUGSjU6iJjlpzHRPuJkK+MrAgPLnOcGYYr6rSGspz7PcG45f9BoHADtFgfCY3zG+O7Skt4LvV5NTjLckohF3G3VlQqckKSbIrLN2mmmx+QY2F5OEd/h"
  ]
  ssh_key_path           = "/home/ivln/workspace/work/RancherVCS/ival-pc-temp.pem"
  server_instance_type   = var.server_instance_type
  server_node_count      = var.roles_per_pool[count.index].quantity
  install_docker_version = var.install_docker_version
  s3_instance_profile    = var.iam_instance_profile
  user_data_parts = [{
    filename     = "register_cluster.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/files/register_cluster.sh", {
      registration_command = module.cluster_v1.registration_command
    })
  }]
}

resource "null_resource" "this" {
  count = local.num_nodes
  connection {
    type        = "ssh"
    host        = local.node_public_ips[count.index]
    user        = "ubuntu"
    port        = 22
    private_key = "/home/ivln/workspace/work/RancherVCS/ival-pc-temp.pem"
  }
  provisioner "remote-exec" {
    inline = [
      module.cluster_v1.registration_command
    ]
  }
}

#TODO: Group nodes into "pools" by role manually by splitting module.aws-infra.nodes_public_ips and module.aws-infra.nodes_private_ips as needed
#TODO: Create script to bootstrap the nodes. Should be able to:
#   - install docker
#   - set the docker storage driver
#   - set the native diff overaly on/off
#   - register the nodes with the Rancher cluster

resource "rancher2_cluster_sync" "this" {
  count      = var.wait_for_active ? 1 : 0
  cluster_id = module.cluster_v1.id
  depends_on = [
    null_resource.this
  ]
}

resource "local_file" "kube_config" {
  content  = var.wait_for_active ? nonsensitive(rancher2_cluster_sync.this[0].kube_config) : module.cluster_v1.kube_config
  filename = "${path.module}/files/kube_config/${terraform.workspace}_kube_config"
}

module "rancher_monitoring" {
  count  = var.install_monitoring && var.wait_for_active ? 1 : 0
  source = "../../rancher-cluster-operations/charts/rancher-monitoring"
  providers = {
    rancher2 = rancher2
  }

  use_v2        = true
  rancher_url   = var.rancher_api_url
  rancher_token = var.rancher_token_key
  charts_branch = var.rancher_charts_branch
  chart_version = var.monitoring_version
  cluster_id    = module.cluster_v1.id
  project_id    = module.cluster_v1.default_project_id

  depends_on = [
    local_file.kube_config
  ]
}

output "cluster_registration_tokens" {
  description = "The cluster registration token"
  value       = module.cluster_v1[*].cluster_registration_token[0]
}

output "node_public_ips" {
  value = local.node_public_ips
}

output "create_node_reqs" {
  value = var.create_node_reqs
}

output "cluster_name" {
  value = local.cluster_name
}

output "cluster_id" {
  value = module.cluster_v1.id
}
