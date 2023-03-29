output "secrets-cluster" {
  value = local.secrets-cluster
}

output "secretsv2-cluster" {
  value = local.secretsv2-cluster
}

output "tokens-cluster" {
  value = local.tokens-cluster
}

output "aws-cloud-creds-cluster" {
  value = local.aws-cloud-creds-cluster
}

# output "linode-cloud-creds-cluster" {
#   value = local.linode-cloud-creds-cluster
# }

output "projects-cluster" {
  value = local.projects-cluster
}

output "users-cluster" {
  value = local.users-cluster
}

output "kube-configs" {
  value = module.generate_kube_config[*].kubeconfig_path
  sensitive = false
}
