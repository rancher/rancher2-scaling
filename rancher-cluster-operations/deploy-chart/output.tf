output "metadata" {
  value = helm_release.local_chart[*].metadata
}
