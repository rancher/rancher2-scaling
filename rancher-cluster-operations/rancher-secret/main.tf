terraform {
  required_version = ">= 0.13"
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
    }
  }
}

locals {
  ### ensure data is base64encoded for rancher2_secret only
  secret_data = { for k, v in var.data : k => base64encode(v) }
}

resource "rancher2_secret" "this" {
  count        = !var.use_v2 && var.create_new ? 1 : 0
  annotations  = var.annotations
  labels       = var.labels
  description  = var.description
  project_id   = var.project_id
  name         = var.name
  namespace_id = var.namespace
  data         = local.secret_data
}

resource "rancher2_secret_v2" "this" {
  count = var.use_v2 && var.create_new ? 1 : 0

  immutable   = var.immutable
  type        = var.type
  annotations = var.annotations
  labels      = var.labels
  cluster_id  = var.cluster_id
  name        = var.name
  namespace   = var.namespace
  data        = var.data
}

data "rancher2_secret" "this" {
  count = var.use_v2 ? 0 : 1

  name         = var.name
  namespace_id = var.namespace
  project_id   = var.project_id
}

data "rancher2_secret_v2" "this" {
  count = var.use_v2 ? 1 : 0

  name       = var.name
  namespace  = var.namespace
  cluster_id = var.cluster_id
}
