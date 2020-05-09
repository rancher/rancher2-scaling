data "aws_vpc" "default" {
  default = false
  id      = var.vpc_id
}

data "aws_subnet_ids" "available" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_route53_zone" "dns_zone" {
  count = local.use_route53
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

data "template_cloudinit_config" "k3s_server" {
  gzip          = false
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    filename     = "cloud-config-base.yaml"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/files/cloud-config-base.yaml", {
      ssh_keys = var.ssh_keys
      }
    )
  }

  part {
    filename     = "00_k3s-install.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/files/k3s-install.sh", {
      install_k3s_version    = local.install_k3s_version,
      k3s_exec               = local.server_k3s_exec,
      k3s_cluster_secret     = local.k3s_cluster_secret,
      is_k3s_server          = true,
      k3s_url                = aws_route53_record.k3s[0].fqdn,
      k3s_datastore_endpoint = local.k3s_datastore_endpoint,
      k3s_datastore_cafile   = local.k3s_datastore_cafile,
      k3s_disable_agent      = local.k3s_disable_agent,
      k3s_tls_san            = local.k3s_tls_san,
      k3s_deploy_traefik     = local.k3s_deploy_traefik
      }
    )
  }

  part {
    filename     = "99_ingress-install.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/files/ingress-install.sh", {
      install_nginx_ingress = local.install_nginx_ingress
      }
    )
  }

  part {
    filename     = "20_rancher-install.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/files/rancher-install.sh", {
      certmanager_version   = local.certmanager_version,
      letsencrypt_email     = local.letsencrypt_email,
      rancher_version       = local.rancher_version,
      rancher_hostname      = "${local.subdomain}.${local.domain}",
      install_rancher       = local.install_rancher,
      install_nginx_ingress = local.install_nginx_ingress,
      install_certmanager   = local.install_certmanager
      rancher_image         = var.rancher_image
      rancher_image_tag     = var.rancher_image_tag
      self_signed           = var.self_signed
      }
    )
  }

  part {
    filename     = "30_register-to-rancher.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/files/register-to-rancher.sh", {
      is_k3s_server        = true,
      install_rancher      = local.install_rancher,
      registration_command = local.registration_command
      }
    )
  }
}

data "template_cloudinit_config" "k3s_agent" {
  gzip          = false
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    filename     = "cloud-config-base.yaml"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/files/cloud-config-base.yaml", {
      ssh_keys = var.ssh_keys
      }
    )
  }

  part {
    filename     = "20_k3s-install.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/files/k3s-install.sh", {
      install_k3s_version    = local.install_k3s_version,
      k3s_exec               = local.agent_k3s_exec,
      k3s_cluster_secret     = local.k3s_cluster_secret,
      is_k3s_server          = false,
      k3s_url                = aws_route53_record.k3s[0].fqdn,
      k3s_datastore_endpoint = local.k3s_datastore_endpoint,
      k3s_datastore_cafile   = local.k3s_datastore_cafile,
      k3s_disable_agent      = local.k3s_disable_agent,
      k3s_tls_san            = local.k3s_tls_san,
      k3s_deploy_traefik     = local.k3s_deploy_traefik
      }
    )
  }
}
