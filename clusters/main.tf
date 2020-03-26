terraform {
  backend "local" {
    path = "rancher.tfstate"
  }
}

locals {
  name                = var.cluster_name
  cluster_count       = var.cluster_count
  cluster_instance    = terraform.workspace
  nodes_per_cluster   = var.ec2_instances_per_cluster
  k3s_cluster_secret  = ""
  install_k3s_version = "v1.17.2+k3s1"
}

provider "aws" {
  region  = "us-east-2"
  profile = "rancher-eng"
}

provider "rancher2" {
  api_url   = var.rancher_api_url
  token_key = var.rancher_token_key
  insecure  = var.self_signed
}

resource "rancher2_cluster" "k3s" {
  count       = local.cluster_count
  name        = "${local.name}-${local.cluster_instance}-${count.index}"
  description = "TF imported cluster ${local.name}-${local.cluster_instance}-${count.index}"
}

resource "aws_spot_instance_request" "k3s-server" {
  ebs_optimized        = true
  instance_type        = var.server_instance_type
  ami                  = data.aws_ami.ubuntu.id
  spot_price           = "1.591"
  wait_for_fulfillment = true
  spot_type            = "one-time"
  user_data = templatefile("${path.module}/files/server_userdata.tmpl",
    {
      cluster_count         = local.cluster_count,
      k3s_cluster_secret    = local.k3s_cluster_secret,
      install_k3s_version   = local.install_k3s_version,
      k3s_server_args       = var.k3s_server_args,
      registration_commands = var.self_signed ? rancher2_cluster.k3s[*].cluster_registration_token[0].insecure_command : rancher2_cluster.k3s[*].cluster_registration_token[0].command,
    }
  )

  tags = {
    Name = "${local.name}-server-${local.cluster_instance}"
    RancherScaling = var.cluster_name
  }

  root_block_device {
    volume_size = "32"
    volume_type = "gp2"
  }
  depends_on = [rancher2_cluster.k3s]
}

# module "k3s-server-asg" {
#   source               = "terraform-aws-modules/autoscaling/aws"
#   version              = "3.0.0"
#   name                 = "${local.name}-server-${local.cluster_instance}"
#   asg_name             = "${local.name}-server-${local.cluster_instance}"
#   instance_type        = "c5.4xlarge"
#   image_id             = data.aws_ami.ubuntu.id
#   user_data            = data.template_file.k3s-server-user_data.rendered
#   ebs_optimized        = true
#   iam_instance_profile = aws_iam_instance_profile.k3s-server.name
#
#   desired_capacity    = 1
#   health_check_type   = "EC2"
#   max_size            = 1
#   min_size            = 1
#   vpc_zone_identifier = [data.aws_subnet.selected.id]
#   spot_price          = "1.591"
#
#   security_groups = [
#     aws_security_group.k3s.id,
#   ]
#
#   lc_name = "${local.name}-server-${local.cluster_instance}"
#
#   root_block_device = [
#     {
#       volume_size = "1000"
#       volume_type = "gp2"
#     },
#   ]
# }

/*
module "k3s-worker" {
  source        = "terraform-aws-modules/autoscaling/aws"
  version       = "3.0.0"
  name          = "${local.name}-worker-${local.cluster_instance}"
  asg_name      = "${local.name}-worker-${local.cluster_instance}"
  instance_type = var.worker_instance_type
  image_id      = data.aws_ami.ubuntu.id
  user_data     = data.template_file.k3s-worker-user_data.rendered
  ebs_optimized = true

  desired_capacity    = local.nodes_per_cluster
  health_check_type   = "EC2"
  max_size            = local.nodes_per_cluster
  min_size            = local.nodes_per_cluster
  vpc_zone_identifier = data.aws_subnet_ids.available.ids
  spot_price          = "1.591"

  security_groups = [
    aws_security_group.k3s.id,
  ]

  lc_name = "${local.name}-worker-${local.cluster_instance}"

  root_block_device = [
    {
      volume_size = "100"
      volume_type = "gp2"
    },
  ]
}
*/
/*
resource "aws_spot_instance_request" "k3s-worker" {
  instance_type        = var.worker_instance_type
  ami                  = data.aws_ami.ubuntu.id
  spot_price           = "1.591"
  wait_for_fulfillment = false
  user_data            = data.template_file.k3s-worker-user_data.rendered
  ebs_optimized        = true


  vpc_security_group_ids = [
    aws_security_group.k3s.id,
  ]

  tags = {
    Name = "${local.name}-worker-${local.cluster_instance}"
  }

  root_block_device {
    volume_size = "100"
    volume_type = "gp2"
  }

  depends_on = [aws_spot_instance_request.k3s-server]
}
*/
