data "aws_caller_identity" "current" {}

data "aws_vpc" "default" {
  default = true
}

# data "cloudinit_config" "this" {
#   gzip          = false
#   base64_encode = true

#   # Main cloud-config configuration file.
#   part {
#     filename     = "cloud-config-base.yaml"
#     content_type = "text/cloud-config"
#     content = templatefile("${path.module}/files/cloud-config-base.tmpl", {
#       ssh_keys = var.ssh_keys
#       }
#     )
#   }

#   part {
#     filename     = "20_k3s-install.sh"
#     content_type = "text/x-shellscript"
#     content = templatefile("${path.module}/files/k3s-install.sh", {
#       sleep_at_startup       = true
#       install_k3s_version    = local.install_k3s_version,
#       k3s_exec               = local.agent_k3s_exec,
#       k3s_cluster_secret     = local.k3s_cluster_secret,
#       is_k3s_server          = false,
#       k3s_url                = aws_route53_record.rancher[0].fqdn,
#       use_custom_datastore   = (length(local.k3s_datastore_endpoint) > 0 && length(local.k3s_datastore_cafile) > 0) ? true : false,
#       k3s_datastore_endpoint = local.k3s_datastore_endpoint,
#       k3s_datastore_cafile   = local.k3s_datastore_cafile,
#       k3s_disable_agent      = local.k3s_disable_agent,
#       k3s_tls_san            = local.k3s_tls_san,
#       k3s_deploy_traefik     = local.k3s_deploy_traefik
#       }
#     )
#   }
# }
