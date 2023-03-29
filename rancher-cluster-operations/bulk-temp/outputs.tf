output "cluster_id" {
  value = var.output_stdout ? data.rancher2_cluster.this.id : null
}

output "tokens" {
  value = var.output_stdout ? local.all_tokens : null
}

output "secrets" {
  value = var.output_stdout ? local.all_secrets : null
}

output "secrets_v2" {
  value = var.output_stdout ? local.all_secrets_v2 : null
}

output "aws_cloud_credentials" {
  value = var.output_stdout ? local.all_aws_credentials : null
}

output "linode_cloud_credentials" {
  value = var.output_stdout ? local.all_linode_credentials : null
}

output "projects" {
  value = var.output_stdout ? local.all_projects : null
}

resource "local_file" "tokens" {
  count    = var.output_local_file ? 1 : 0
  content  = jsonencode(local.all_tokens)
  filename = "${path.module}/files/${terraform.workspace}_all_tokens.txt"
}

resource "local_file" "secrets" {
  count    = var.output_local_file ? 1 : 0
  content  = jsonencode(local.all_secrets)
  filename = "${path.module}/files/${terraform.workspace}_all_secrets.txt"
}

resource "local_file" "secrets_v2" {
  count    = var.output_local_file ? 1 : 0
  content  = jsonencode(local.all_secrets_v2)
  filename = "${path.module}/files/${terraform.workspace}_all_secrets_v2.txt"
}

resource "local_file" "aws_credentials" {
  count    = var.output_local_file ? 1 : 0
  content  = jsonencode(local.all_aws_credentials)
  filename = "${path.module}/files/${terraform.workspace}_all_aws_credentials.txt"
}

resource "local_file" "linode_credentials" {
  count    = var.output_local_file ? 1 : 0
  content  = jsonencode(local.all_linode_credentials)
  filename = "${path.module}/files/${terraform.workspace}_all_linode_credentials.txt"
}

resource "local_file" "projects" {
  count    = var.output_local_file ? 1 : 0
  content  = jsonencode(local.all_projects)
  filename = "${path.module}/files/${terraform.workspace}_all_projects.txt"
}
