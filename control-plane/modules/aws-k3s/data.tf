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
    content = templatefile("${path.module}/files/cloud-config-base.tmpl", {
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
      use_custom_datastore   = (length(local.k3s_datastore_endpoint) > 0 && length(local.k3s_datastore_cafile) > 0) ? true : false,
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
      certmanager_version        = local.certmanager_version,
      letsencrypt_email          = local.letsencrypt_email,
      rancher_image              = local.rancher_image,
      rancher_image_tag          = local.rancher_image_tag,
      install_monitoring         = var.create_agent_nlb,
      use_new_monitoring_crd_url = local.use_new_monitoring_crd_url,
      monitoring_version         = var.monitoring_version,
      rancher_chart_tag          = local.rancher_chart_tag,
      rancher_version            = local.rancher_version,
      rancher_password           = local.rancher_password,
      use_new_bootstrap          = var.use_new_bootstrap,
      rancher_node_count         = var.server_node_count,
      rancher_hostname           = "${local.subdomain}.${local.domain}",
      install_rancher            = local.install_rancher,
      install_nginx_ingress      = local.install_nginx_ingress,
      install_certmanager        = local.install_certmanager,
      install_byo_certs          = length(local.byo_certs_bucket_path) > 0 ? true : false,
      byo_certs_bucket_path      = local.byo_certs_bucket_path,
      s3_bucket_region           = local.s3_bucket_region,
      private_ca                 = length(local.private_ca_file) > 0 ? true : false,
      private_ca_file            = local.private_ca_file,
      tls_cert_file              = local.tls_cert_file,
      tls_key_file               = local.tls_key_file
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
  count         = local.agent_node_count > 0 && var.create_agent_nlb ? 1 : 0
  gzip          = false
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    filename     = "cloud-config-base.yaml"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/files/cloud-config-base.tmpl", {
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
      use_custom_datastore   = (length(local.k3s_datastore_endpoint) > 0 && length(local.k3s_datastore_cafile) > 0) ? true : false,
      k3s_datastore_endpoint = local.k3s_datastore_endpoint,
      k3s_datastore_cafile   = local.k3s_datastore_cafile,
      k3s_disable_agent      = local.k3s_disable_agent,
      k3s_tls_san            = local.k3s_tls_san,
      k3s_deploy_traefik     = local.k3s_deploy_traefik
      }
    )
  }
}

data "rancher2_cluster" "local" {
  count = local.install_rancher ? 1 : 0
  name  = "local"
  depends_on = [
    rancher2_bootstrap.admin
  ]
}
