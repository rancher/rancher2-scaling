output "cluster_yaml" {
  value = var.k8s_distribution == "rke1" ? nonsensitive(module.rke1[0].cluster_yaml) : null
}
