output "subnet_id" {
  value = local.instance_subnet_id
}

output "cloud_cred" {
  value = data.rancher2_cloud_credential.existing_cred.id
}

output "roles_map" {
  value = local.roles_map
}
