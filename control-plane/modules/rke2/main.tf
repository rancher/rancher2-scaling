terraform {
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
    }
    null = {
      source = "hashicorp/null"
    }
    random = {
      source = "hashicorp/random"
    }
    cloudinit = {
      source = "hashicorp/cloudinit"
    }
  }
}

locals {
  instance_names = "${var.name}-rke2-ha"
  tags = {
    "Owner"       = "${var.user}",
    "DoNotDelete" = "true",
    "managed-by"  = "Terraform",
    "Identifier"  = "${var.name}",
  }
}

## Provision LB, and Auto Scaling Groups of server nodes
module "aws_infra_rke2" {
  source = "git::https://github.com/git-ival/rke2-aws-tf.git//?ref=update-to-upstream"

  cluster_name             = var.name
  fqdn                     = aws_route53_record.public.fqdn
  controlplane_internal    = var.internal_lb
  unique_suffix            = false
  vpc_id                   = var.vpc_id
  subnets                  = var.subnets
  ami                      = var.ami != null ? var.ami : data.aws_ami.ubuntu.id
  extra_security_group_ids = [aws_security_group.ingress_egress.id, aws_security_group.rancher.id]
  extra_target_group_arns  = [aws_lb_target_group.server_80.arn, aws_lb_target_group.server_443.arn]
  tags                     = local.tags
  servers                  = var.server_node_count
  instance_type            = var.server_instance_type
  iam_instance_profile     = var.iam_instance_profile
  ssh_authorized_keys      = var.ssh_keys
  rke2_version             = var.rke2_version
  rke2_channel             = var.rke2_channel
  rke2_config              = var.rke2_config
  pre_userdata             = "apt update && apt upgrade"
  post_userdata            = <<-EOT
    cat <<-EOF > /var/lib/rancher/rke2/server/manifests/rke2-ingress-nginx.yaml
    apiVersion: helm.cattle.io/v1
    kind: HelmChartConfig
    metadata:
      name: rke2-ingress-nginx
      namespace: kube-system
    spec:
      valuesContent: |-
        controller:
          kind: DaemonSet
          daemonset:
            useHostPort: true
    EOF
  EOT
}

## Provision Auto Scaling Group of agent to auto-join cluster with taints and labels for monitoring only
module "rke2_monitor_pool" {
  count  = var.setup_monitoring_agent ? 1 : 0
  source = "git::https://github.com/git-ival/rke2-aws-tf.git//modules/agent-nodepool?ref=update-to-upstream"

  name                     = "monitoring"
  vpc_id                   = var.vpc_id
  subnets                  = var.subnets
  ami                      = var.ami != null ? var.ami : data.aws_ami.ubuntu.id
  instance_type            = var.server_instance_type
  tags                     = local.tags
  extra_security_group_ids = [aws_security_group.ingress_egress.id, aws_security_group.rancher.id]
  extra_target_group_arns  = [aws_lb_target_group.server_80.arn, aws_lb_target_group.server_443.arn]
  iam_instance_profile     = var.iam_instance_profile
  ssh_authorized_keys      = var.ssh_keys
  asg                      = { min : 1, max : 1, desired : 1 }
  rke2_version             = var.rke2_version # https://docs.rke2.io/install/install_options/install_options/#configuring-the-linux-installation-script
  rke2_channel             = var.rke2_channel
  rke2_config              = <<-EOT
    node-taint: monitoring=yes:NoSchedule
    node-label: monitoring=yes
    EOT

  # Required input sourced from parent rke2 module, contains configuration that agents use to join existing cluster
  cluster_data = module.aws_infra_rke2.cluster_data

  depends_on = [
    module.aws_infra_rke2
  ]
}

resource "null_resource" "wait_for_monitor_to_register" {
  count = var.setup_monitoring_agent ? 1 : 0
  provisioner "local-exec" {
    command = <<-EOT
    timeout --preserve-status 5m bash -c -- 'until [ "$${nodes}" = "${var.server_node_count + 1}" ]; do
        sleep 5
        nodes="$(kubectl --kubeconfig <(echo $KUBECONFIG | base64 --decode) get nodes --no-headers | wc -l | awk '\''{$1=$1;print}'\'')"
        echo "rke2 nodes: $${nodes}"
    done'
    EOT
    environment = {
      KUBECONFIG = base64encode(nonsensitive(module.aws_infra_rke2.kubeconfig_content))
    }
  }

  depends_on = [
    module.rke2_monitor_pool
  ]
}
