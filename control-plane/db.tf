resource "aws_security_group" "database" {
  name   = "${local.name}-database"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "database_self" {
  type              = "ingress"
  from_port         = var.db_port
  to_port           = var.db_port
  protocol          = "TCP"
  self              = true
  security_group_id = aws_security_group.database.id
}


module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = local.identifier

  # All available versions: http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html#MySQL.Concepts.VersionMgmt
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  major_engine_version = var.db_engine_version

  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  storage_encrypted = var.db_storage_encrypted
  iops              = var.db_iops
  storage_type      = var.db_storage_type

  subnet_ids             = data.aws_subnet_ids.all.ids
  vpc_security_group_ids = [data.aws_security_group.default.id, aws_security_group.database.id]
  multi_az               = local.db_multi_az
  deletion_protection    = false

  name     = var.db_name
  username = var.db_username
  password = var.db_password
  port     = var.db_port

  create_db_parameter_group    = false
  create_db_subnet_group       = false
  create_db_option_group       = false
  performance_insights_enabled = false

  db_subnet_group_name    = "default"
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
