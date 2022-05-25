terraform {
  required_version = ">= 1.1.0"
  required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
      version = ">= 1.10.0"
    }
  }
}

resource "rancher2_cloud_credential" "this" {
  count = var.create_new ? 1 : 0
  name  = var.name

  dynamic "amazonec2_credential_config" {
    for_each = var.cloud_provider == "aws" ? [1] : []
    content {
      access_key     = var.credential_config.access_key
      secret_key     = var.credential_config.secret_key
      default_region = var.credential_config.region
    }
  }
  dynamic "linode_credential_config" {
    for_each = var.cloud_provider == "linode" ? [1] : []
    content {
      token = var.credential_config.token
    }
  }
}

### Only create a new cloud_credential if the caller has defined that a new cloud_credential should be created
### else, look for an existing cloud_credential with the given name
data "rancher2_cloud_credential" "this" {
  name = var.create_new ? rancher2_cloud_credential.this[0].name : var.name
}

output "id" {
  value = data.rancher2_cloud_credential.this.id
}

output "name" {
  value = data.rancher2_cloud_credential.this.name
}

output "cloud_cred" {
  value = data.rancher2_cloud_credential.this
}
