output "id" {
  value = var.use_v2 ? data.rancher2_secret_v2.this[0].id : data.rancher2_secret.this[0].id
}

output "resource_version" {
  value = var.use_v2 ? data.rancher2_secret_v2.this[0].resource_version : null
}

output "immutable" {
  value = var.use_v2 ? data.rancher2_secret_v2.this[0].immutable : null
}

output "type" {
  value = var.use_v2 ? data.rancher2_secret_v2.this[0].type : null
}

output "annotations" {
  value = var.use_v2 ? data.rancher2_secret_v2.this[0].annotations : data.rancher2_secret.this[0].annotations
}

output "labels" {
  value = var.use_v2 ? data.rancher2_secret_v2.this[0].labels : data.rancher2_secret.this[0].labels
}

output "description" {
  value = var.use_v2 ? null : data.rancher2_secret.this[0].description
}

output "data" {
  value = var.use_v2 ? data.rancher2_secret_v2.this[0].data : data.rancher2_secret.this[0].data
}
