/*
data "terraform_remote_state" "server" {
  backend = "local"

  config = {
    path = "${path.module}/../server/rancher.tfstate"
  }
}
*/

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "available" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu-minimal/images/*/ubuntu-bionic-18.04-*"]
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

/*
data "template_file" "k3s-server-user_data" {
  count    = local.cluster_count
  template = file("${path.module}/files/server_userdata.tmpl")

  vars = {
    k3s_cluster_secret  = local.k3s_cluster_secret
    install_k3s_version = local.install_k3s_version
    k3s_server_args     = var.k3s_server_args
    register            = rancher2_cluster.k3s[count.index].cluster_registration_token[0].command
  }
}
*/

data "template_file" "k3s-worker-user_data" {
  template = file("${path.module}/files/worker_userdata.tmpl")

  vars = {
    k3s_url             = aws_spot_instance_request.k3s-server.private_ip
    k3s_cluster_secret  = local.k3s_cluster_secret
    install_k3s_version = local.install_k3s_version
    k3s_per_node        = var.k3s_per_node
    k3s_exec            = ""
  }
}

