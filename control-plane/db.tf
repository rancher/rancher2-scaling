resource "aws_security_group" "database" {
  count  = var.k8s_distribution == "k3s" ? 1 : 0
  name   = "${local.name}-database"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "database_self" {
  count             = var.k8s_distribution == "k3s" ? 1 : 0
  type              = "ingress"
  from_port         = var.db_port
  to_port           = var.db_port
  protocol          = "TCP"
  self              = true
  security_group_id = aws_security_group.database[0].id
}


module "db" {
  count   = var.k8s_distribution == "k3s" ? 1 : 0
  source  = "terraform-aws-modules/rds/aws"
  version = ">= 3.2"

  identifier = local.identifier

  # All available versions: http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html#MySQL.Concepts.VersionMgmt
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  major_engine_version = var.db_engine_version

  instance_class      = var.db_instance_class
  allocated_storage   = var.db_allocated_storage
  storage_encrypted   = var.db_storage_encrypted
  iops                = var.db_iops
  storage_type        = var.db_storage_type
  skip_final_snapshot = var.db_skip_final_snapshot

  subnet_ids                 = data.aws_subnets.all.ids
  vpc_security_group_ids     = [data.aws_security_group.default.id, aws_security_group.database[0].id]
  multi_az                   = false
  auto_minor_version_upgrade = false
  deletion_protection        = false

  db_name                      = var.db_name
  username                     = var.db_username
  port                         = var.db_port
  create_db_parameter_group    = false
  create_db_subnet_group       = false
  create_db_option_group       = false
  performance_insights_enabled = false

  db_subnet_group_name = var.db_subnet_group_name != null ? var.db_subnet_group_name : (var.aws_region == "us-west-1" || var.aws_region == "us-east-1") ? "default-${data.aws_vpc.default.id}" : "default"

  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 0

  tags = {
    "rancher.user" = data.aws_caller_identity.current.user_id
  }

  parameters = [
  ]

  options = [
  ]
}
