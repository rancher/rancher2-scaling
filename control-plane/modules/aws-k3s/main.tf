terraform {
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
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
  install_k3s_version         = var.install_k3s_version
  k3s_cluster_secret          = var.k3s_cluster_secret != null ? var.k3s_cluster_secret : random_password.k3s_cluster_secret.result
  server_instance_type        = var.server_instance_type
  agent_instance_type         = var.agent_instance_type
  agent_image_id              = var.agent_image_id != null ? var.agent_image_id : data.aws_ami.ubuntu.id
  server_image_id             = var.server_image_id != null ? var.server_image_id : data.aws_ami.ubuntu.id
  aws_azs                     = var.aws_azs
  public_subnets              = length(var.public_subnets) > 0 ? var.public_subnets : data.aws_subnets.available.ids
  private_subnets             = length(var.private_subnets) > 0 ? var.private_subnets : data.aws_subnets.available.ids
  server_node_count           = var.server_node_count
  agent_node_count            = var.agent_node_count
  ssh_keys                    = var.ssh_keys
  deploy_rds                  = var.k3s_datastore_endpoint != "sqlite" ? 1 : 0
  db_instance_type            = var.db_instance_type
  db_user                     = var.db_user
  db_pass                     = var.db_pass
  db_name                     = var.db_name != null ? var.db_name : var.name
  db_node_count               = var.k3s_datastore_endpoint != "sqlite" ? var.db_node_count : 0
  k3s_datastore_cafile        = var.k3s_datastore_cafile
  k3s_datastore_endpoint      = var.k3s_datastore_endpoint != "sqlite" ? "mysql://${local.db_user}:${local.db_pass}@tcp(${var.k3s_datastore_endpoint})/${var.db_name}" : ""
  k3s_disable_agent           = var.k3s_disable_agent ? "--disable-agent" : ""
  k3s_tls_san                 = var.k3s_tls_san != null ? var.k3s_tls_san : "--tls-san ${aws_route53_record.k3s[0].fqdn}"
  k3s_deploy_traefik          = var.k3s_deploy_traefik ? "" : "--disable=traefik"
  server_k3s_exec             = var.server_k3s_exec
  agent_k3s_exec              = var.agent_k3s_exec
  certmanager_version         = var.certmanager_version
  rancher_password            = var.rancher_password
  rancher_image               = var.rancher_image
  rancher_image_tag           = var.rancher_image_tag
  rancher_chart_tag           = var.rancher_chart_tag
  rancher_version             = var.rancher_version
  use_new_monitoring_crd_url  = length(regexall("2.6", local.rancher_chart_tag)) > 0 ? true : false
  letsencrypt_email           = var.letsencrypt_email
  byo_certs_bucket_path       = var.byo_certs_bucket_path
  s3_instance_profile         = var.s3_instance_profile
  s3_bucket_region            = length(var.s3_bucket_region) > 0 ? var.s3_bucket_region : var.aws_region
  private_ca_file             = var.private_ca_file
  tls_cert_file               = var.tls_cert_file
  tls_key_file                = var.tls_key_file
  domain                      = var.domain
  r53_domain                  = length(var.r53_domain) > 0 ? var.r53_domain : local.domain
  private_subnets_cidr_blocks = var.private_subnets_cidr_blocks
  public_subnets_cidr_blocks  = var.public_subnets_cidr_blocks
  skip_final_snapshot         = var.skip_final_snapshot
  install_certmanager         = var.install_certmanager
  install_rancher             = var.install_rancher
  install_nginx_ingress       = var.install_nginx_ingress
  create_agent_nlb            = var.create_agent_nlb ? 1 : 0
  registration_command        = var.registration_command
  use_route53                 = var.use_route53 ? 1 : 0
  subdomain                   = var.subdomain != null ? var.subdomain : var.name
  tags = {
    "rancher.user" = var.user,
    "Owner"        = var.user,
    "DoNotDelete"  = "true"
  }
}

resource "random_password" "k3s_cluster_secret" {
  length  = 30
  special = false
}

resource "null_resource" "wait_for_rancher" {
  count = local.install_rancher ? 1 : 0
  provisioner "local-exec" {
    command = <<EOF
until echo "$${subject}" | grep -q "CN=${local.subdomain}.${local.domain}" || echo "$${subject}" | grep -q "CN=\*.${local.domain}" ; do
    sleep 5
    subject=$(curl -vk -m 2 "https://${local.subdomain}.${local.domain}/ping" 2>&1 | grep "subject:")
    echo "Subject: $${subject}"
done
while [ "$${resp}" != "pong" ]; do
    resp=$(curl -sSk -m 2 "https://${local.subdomain}.${local.domain}/ping")
    echo "Rancher Response: $${resp}"
    if [ "$${resp}" != "pong" ]; then
      sleep 10
    fi
done
EOF

    environment = {
      RANCHER_HOSTNAME = "${local.subdomain}.${local.domain}"
    }
  }

  depends_on = [
    aws_autoscaling_group.k3s_server,
    aws_autoscaling_group.k3s_agent,
  ]

}

resource "rancher2_bootstrap" "admin" {
  count            = (local.install_rancher) ? 1 : 0
  initial_password = var.use_new_bootstrap ? local.rancher_password : null
  password         = local.rancher_password
  depends_on       = [null_resource.wait_for_rancher]
}
