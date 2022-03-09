terraform {
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
    null = {
      source = "hashicorp/null"
    }
    random = {
      source = "hashicorp/random"
    }
    template = {
      source = "hashicorp/template"
    }
  }
}

locals {
  name                        = var.name
  instance_names              = "${local.name}-HA"
  server_instance_type        = var.server_instance_type
  server_image_id             = var.server_image_id != null ? var.server_image_id : data.aws_ami.ubuntu.id
  aws_azs                     = var.aws_azs
  public_subnets              = length(var.public_subnets) > 0 ? var.public_subnets : data.aws_subnets.available.ids
  private_subnets             = length(var.private_subnets) > 0 ? var.private_subnets : data.aws_subnets.available.ids
  server_node_count           = var.server_node_count
  ssh_keys                    = var.ssh_keys
  install_docker_version      = trim(var.install_docker_version, " ")
  s3_instance_profile         = var.s3_instance_profile
  domain                      = var.domain
  r53_domain                  = length(var.r53_domain) > 0 ? var.r53_domain : local.domain
  private_subnets_cidr_blocks = length(var.private_subnets_cidr_blocks) > 0 ? var.private_subnets_cidr_blocks : ["0.0.0.0/0"]
  create_external_nlb         = var.create_external_nlb ? 1 : 0
  use_route53                 = var.use_route53 ? 1 : 0
  subdomain                   = var.subdomain != null ? var.subdomain : var.name
  # Handle case where target group/load balancer name exceeds 32 character limit without creating illegal names
  internal_lb_name       = "${substr(local.name, 0, 27)}-int"
  agent_external_lb_name = "${substr(local.name, 0, 27)}-ext"
  external_lb_name       = substr(local.name, 0, 31)
  k8s_cluster_tag        = "kubernetes.io/cluster/${local.subdomain}"
  custom_tags = [
    {
      key   = local.k8s_cluster_tag
      value = "owned"
    },
    {
      key   = "rancher.user"
      value = var.user
    }
  ]
  asg_tags = concat(
    [
      {
        "key"   = "Name"
        "value" = local.instance_names
      },
      {
        "key"   = "Owner"
        "value" = var.user
      },
      {
        "key"   = "DoNotDelete"
        "value" = "true"
      }
    ], local.custom_tags
  )
}

resource "null_resource" "wait_for_bootstrap" {
  count = var.server_node_count + 1

  connection {
    type        = "ssh"
    host        = coalesce(data.aws_instances.nodes.public_ips[count.index], data.aws_instances.nodes.private_ips[count.index])
    user        = var.server_instance_ssh_user
    port        = 22
    private_key = file(var.ssh_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait"
    ]
  }

  depends_on = [
    aws_autoscaling_group.rke1_server
  ]
}
