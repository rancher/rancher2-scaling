data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/*/ubuntu-bionic-18.04-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# data "aws_instances" "nodes" {
#   instance_tags = local.tags
#   depends_on = [
#     module.aws_infra_rke2
#   ]
# }

data "aws_s3_object" "kube_config" {
  bucket = split("/", split("//", module.aws_infra_rke2.kubeconfig_s3_path)[1])[0]
  key    = split("/", split("//", module.aws_infra_rke2.kubeconfig_s3_path)[1])[1]

  # depends_on = [
  #   null_resource.wait_for_bootstrap
  # ]

  depends_on = [
    module.aws_infra_rke2
  ]
}

data "aws_route53_zone" "dns_zone" {
  name = var.domain
}
