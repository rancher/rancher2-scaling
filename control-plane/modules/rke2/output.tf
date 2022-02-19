output "cluster_data" {
  description = "Map of cluster data required by agent pools for joining cluster, do not modify this"
  value       = module.aws_infra_rke2.cluster_data
}

output "kube_config" {
  value = data.aws_s3_object.kube_config.body
}
