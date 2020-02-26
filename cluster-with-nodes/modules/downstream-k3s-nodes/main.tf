resource "aws_spot_instance_request" "k3s-worker" {
  //ebs_optimized = true
  count = var.instances
  instance_type = var.worker_instance_type
  ami = var.ami_id
  spot_price           = var.spot_price
  wait_for_fulfillment = true
  spot_type = "one-time"

  user_data = templatefile("${path.module}/files/worker_userdata.tmpl",
    {
      current_instance      = count.index,
      agents_per_node       = var.k3s_agents_per_node,
      k3s_endpoint          = var.k3s_endpoint,
      k3s_token             = var.k3s_token,
      install_k3s_version   = var.install_k3s_version,
      consul_store          = var.consul_store
    }
  )

  tags = {
    Name = "${var.prefix}-worker-${count.index}"
    RancherScaling = "true"
  }

  root_block_device {
    volume_size = "32"
    volume_type = "gp2"
  }
}