output "subnet_id" {
  value = local.instance_subnet_id
}

output "cloud_cred" {
  value = data.rancher2_cloud_credential.this.id
}
