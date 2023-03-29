data "aws_region" "current" {}

data "aws_vpc" "default" {
  default = false
  id      = var.vpc_id
}

data "aws_subnets" "available" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_route53_zone" "dns_zone" {
  count = local.use_route53 ? 1 : 0
  name  = local.r53_domain
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/*/ubuntu-bionic-18.04-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "cloudinit_config" "server" {
  gzip          = false
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    filename     = "00_cloud-config-base.yaml"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/files/cloud-config-base.tmpl", {
      ssh_keys = var.ssh_keys,
      }
    )
  }

  # part {
  #   filename     = "01_base.sh"
  #   content_type = "text/x-shellscript"
  #   content      = file("${path.module}/files/base.sh")
  #   merge_type   = "list(append)+dict(recurse_array)+str()"
  # }

  part {
    filename     = "02_k8s-setup.sh"
    content_type = "text/x-shellscript"
    content      = file("${path.module}/files/k8s-setup.sh")
    merge_type   = "list(append)+dict(recurse_array)+str()"
  }

  part {
    filename     = "03_docker-install.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/files/docker-install.sh", {
      install_docker_version = local.install_docker_version,
      }
    )
    merge_type = "list(append)+dict(recurse_array)+str()"
  }
  dynamic "part" {
    for_each = var.user_data_parts
    content {
      filename     = part.value.filename
      content_type = part.value.content_type
      content      = part.value.content
    }
  }
}

data "aws_instances" "nodes" {
  instance_tags = {
    Name  = local.instance_names
    Owner = var.user
  }
  depends_on = [
    aws_autoscaling_group.server
  ]
}

data "aws_security_group" "extras" {
  count = length(var.extra_security_groups)
  name  = var.extra_security_groups[count.index]
}
