terraform {
  required_version = ">= 0.14"
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
    }
    local = {
      source = "hashicorp/local"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

locals {
  name_prefix                               = length(var.name_prefix) > 0 ? var.name_prefix : "${terraform.workspace}-bulk"
  secret_name_prefix                        = "${local.name_prefix}-secret"
  aws_cloud_cred_name_prefix                = "${local.name_prefix}-aws-cloud-cred"
  linode_cloud_cred_name_prefix             = "${local.name_prefix}-linode-cloud-cred"
  project_name_prefix                       = "${local.name_prefix}-project"
  namespace_name_prefix                     = "${local.name_prefix}-namespace"
  global_role_name_prefix                   = "${local.name_prefix}-global-role"
  user_name_prefix                          = "${local.name_prefix}-user"
  global_role_binding_name_prefix           = "${local.name_prefix}-grb"
  role_template_name_prefix                 = "${local.name_prefix}-role-template"
  cluster_role_template_binding_name_prefix = "${local.name_prefix}-crtb"
  project_role_template_binding_name_prefix = "${local.name_prefix}-prtb"
  all_tokens = [for token in rancher2_token.this[*] : {
    "id"          = token.id,
    "name"        = token.name,
    "enabled"     = token.enabled,
    "expired"     = token.expired,
    "user_id"     = token.user_id,
    "cluster_id"  = data.rancher2_cluster.this.id,
    "annotations" = token.annotations,
    "labels"      = token.labels,
    "access_key"  = token.access_key,
    "secret_key"  = nonsensitive(token.secret_key),
    "token"       = nonsensitive(token.token)
  }]
  all_secrets = [for secret in module.secrets[*] : {
    "name"         = "${local.secret_name_prefix}-${index(module.secrets[*], secret)}",
    "id"           = secret.id,
    "namespace_id" = data.rancher2_namespace.this.id,
    "cluster_id"   = data.rancher2_cluster.this.id,
    "project_id"   = data.rancher2_project.this[0].id,
    "description"  = secret.description,
    "annotations"  = secret.annotations,
    "labels"       = secret.labels,
    "data"         = { for k, v in secret.data : k => base64decode(v) }
  }]
  all_secrets_v2 = [for secret_v2 in module.secrets_v2[*] : {
    "name"             = "${local.secret_name_prefix}v2-${index(module.secrets_v2[*], secret_v2)}",
    "id"               = secret_v2.id,
    "cluster_id"       = data.rancher2_cluster.this.id,
    "resource_version" = secret_v2.resource_version,
    "immutable"        = secret_v2.immutable,
    "type"             = secret_v2.type,
    "namespace"        = var.namespace,
    "annotations"      = secret_v2.annotations,
    "labels"           = secret_v2.labels,
    "data"             = secret_v2.data
  }]
  all_aws_credentials    = [for cred in module.aws_cloud_credentials[*].cloud_cred : cred]
  all_linode_credentials = [for cred in module.linode_cloud_credentials[*].cloud_cred : cred]
  all_projects           = [for project in rancher2_project.this[*] : project]

  user_name_ref_pattern = length(var.user_name_ref_pattern) > 0 ? var.user_name_ref_pattern : local.user_name_prefix
  generated_users = var.create_new_users ? {} : {
    for i in range(var.num_users) : "${local.user_name_ref_pattern}-${i}" => {
      name     = "${local.user_name_ref_pattern}-${i}"
      username = "${local.user_name_ref_pattern}-${i}"
    }
  }
  existing_users = length(var.users) > 0 ? { for i, user in var.users : i => user } : {}
  created_users  = var.create_new_users && var.num_users > 0 ? { for i, user in rancher2_user.this[*] : i => user } : {}

  all_users   = (var.user_cluster_binding || var.user_project_binding || var.user_global_binding) ? merge(local.created_users, local.generated_users, local.existing_users) : {}
  found_users = data.rancher2_user.this
}

data "rancher2_cluster" "this" {
  name = var.cluster_name
}

data "rancher2_project" "this" {
  count      = length(var.project) > 0 ? 1 : 0
  cluster_id = data.rancher2_cluster.this.id
  name       = var.project
}

data "rancher2_namespace" "this" {
  name       = var.namespace
  project_id = data.rancher2_project.this[0].id
}

resource "rancher2_token" "this" {
  count       = var.num_tokens
  cluster_id  = data.rancher2_cluster.this.id
  description = "Bulk Token ${count.index}"
  renew       = true
  ttl         = 0
}

module "secrets" {
  source      = "../rancher-secret"
  use_v2      = false
  count       = var.use_v2 ? 0 : var.num_secrets
  create_new  = true
  name        = "${local.secret_name_prefix}-${count.index}"
  description = "Bulk Secret ${count.index}"
  project_id  = data.rancher2_project.this[0].id
  namespace   = data.rancher2_namespace.this.id
  data        = var.secret_data
}

module "secrets_v2" {
  source     = "../rancher-secret"
  use_v2     = true
  count      = var.use_v2 ? var.num_secrets : 0
  create_new = true
  immutable  = true
  type       = "Opaque"
  name       = "${local.secret_name_prefix}v2-${count.index}"
  cluster_id = data.rancher2_cluster.this.id
  namespace  = var.namespace
  data       = var.secret_data
}

module "aws_cloud_credentials" {
  source         = "../rancher-cloud-credential"
  count          = var.num_aws_credentials
  create_new     = true
  name           = "${local.aws_cloud_cred_name_prefix}-${count.index}"
  cloud_provider = "aws"
  credential_config = {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region     = var.aws_region
  }
}

module "linode_cloud_credentials" {
  source         = "../rancher-cloud-credential"
  count          = var.num_linode_credentials
  create_new     = true
  name           = "${local.linode_cloud_cred_name_prefix}-${count.index}"
  cloud_provider = "linode"
  credential_config = {
    token = var.linode_token
  }
}

resource "rancher2_project" "this" {
  count            = var.num_projects
  name             = "${local.project_name_prefix}-${count.index}"
  cluster_id       = data.rancher2_cluster.this.id
  wait_for_cluster = true
}

resource "rancher2_namespace" "this" {
  count            = var.num_namespaces
  name             = "${local.namespace_name_prefix}-${count.index}"
  project_id       = data.rancher2_project.this[0].id
  wait_for_cluster = true
}

# TODO: Add `rancher2_user`, `rancher2_global_role `, `rancher2_global_role_binding` and/or `rancher2_role_template`, and `rancher2_project_role_template_binding` creation

# Create new users
resource "rancher2_user" "this" {
  count    = var.create_new_users ? var.num_users : 0
  name     = "${local.user_name_prefix}-${count.index}"
  username = "${local.user_name_prefix}-${count.index}"
  password = var.user_password
  enabled  = true
}

data "rancher2_user" "this" {
  for_each = local.all_users
  name     = length(each.value.name) > 0 ? each.value.name : null
  username = length(each.value.username) > 0 ? each.value.username : null
  depends_on = [
    rancher2_user.this
  ]
}

resource "random_id" "this" {
  count       = var.user_global_binding || var.user_cluster_binding || var.user_project_binding ? 1 : 0
  byte_length = 2
}

resource "rancher2_global_role" "this" {
  count            = var.user_global_binding ? 1 : 0
  name             = "${local.global_role_name_prefix}-${random_id.this[0].dec}"
  new_user_default = true
  description      = "Terraform global role scale test"

  rules {
    api_groups = ["*"]
    resources  = ["secrets"]
    verbs      = ["create"]
  }
}

# Create a new rancher2 global_role_binding for each user
resource "rancher2_global_role_binding" "this" {
  for_each       = var.user_global_binding ? local.found_users : {}
  name           = "${each.value.name}-${random_id.this[0].dec}"
  global_role_id = rancher2_global_role.this[0].id
  user_id        = each.value.id
}

resource "rancher2_role_template" "cluster" {
  count        = var.user_cluster_binding ? 1 : 0
  name         = "${local.role_template_name_prefix}-cluster-${random_id.this[0].dec}"
  context      = "cluster"
  default_role = true
  description  = "Terraform role template scale test"
  rules {
    api_groups = ["*"]
    resources  = ["secrets"]
    verbs      = ["create"]
  }
}

resource "rancher2_cluster_role_template_binding" "this" {
  for_each         = var.user_cluster_binding ? local.found_users : {}
  name             = "${each.value.name}-${random_id.this[0].dec}"
  cluster_id       = data.rancher2_cluster.this.id
  role_template_id = rancher2_role_template.cluster[0].id
  user_id          = each.value.id
}

resource "rancher2_project" "user_roles" {
  count      = var.user_project_binding ? 1 : 0
  name       = "${local.project_name_prefix}-user-roles-${random_id.this[0].dec}"
  cluster_id = data.rancher2_cluster.this.id
}

resource "rancher2_role_template" "project" {
  count        = var.user_project_binding ? 1 : 0
  name         = "${local.role_template_name_prefix}-project-${random_id.this[0].dec}"
  context      = "project"
  default_role = true
  description  = "Terraform role template scale test"
  rules {
    api_groups = ["*"]
    resources  = ["secrets"]
    verbs      = ["create"]
  }
}

resource "rancher2_project_role_template_binding" "this" {
  for_each         = var.user_project_binding ? local.found_users : {}
  name             = "${each.value.name}-${random_id.this[0].dec}"
  project_id       = rancher2_project.user_roles[0].id
  role_template_id = rancher2_role_template.project[0].id
  user_id          = each.value.id
}
