data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_availability_zone" "selected_az" {
  zone_id = local.instance_az_zone_id
}

data "aws_security_group" "selected" {
  for_each = toset(var.security_groups)
  name     = each.key
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "available" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name   = "availability-zone-id"
    values = ["${data.aws_availability_zone.selected_az.zone_id}"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["${var.image}"]
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
