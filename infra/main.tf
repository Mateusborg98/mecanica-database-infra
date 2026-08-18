locals {
  name = "mecanica-${var.environment}"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_db_subnet_group" "database" {
  name       = "${local.name}-database"
  subnet_ids = data.aws_subnets.default.ids

  description = "Subnets used by the Mecanica PostgreSQL database."

  lifecycle {
    precondition {
      condition     = length(data.aws_subnets.default.ids) >= 2
      error_message = "At least two subnets are required for the RDS subnet group."
    }
  }
}

resource "aws_security_group" "database" {
  name        = "${local.name}-database"
  description = "Restricts access to the Mecanica PostgreSQL database."
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "postgresql_from_vpc" {
  security_group_id = aws_security_group.database.id
  description       = "PostgreSQL access from workloads inside the VPC."

  cidr_ipv4   = data.aws_vpc.default.cidr_block
  from_port   = 5432
  ip_protocol = "tcp"
  to_port     = 5432
}

resource "aws_db_instance" "postgresql" {
  identifier = "${local.name}-postgresql"

  engine         = "postgres"
  engine_version = var.postgres_engine_version
  instance_class = var.database_instance_class

  db_name  = var.database_name
  username = var.database_username
  password = var.database_password
  port     = 5432

  allocated_storage     = var.allocated_storage_gib
  max_allocated_storage = 0
  storage_type          = "gp3"
  storage_encrypted     = true

  db_subnet_group_name   = aws_db_subnet_group.database.name
  vpc_security_group_ids = [aws_security_group.database.id]
  publicly_accessible    = false
  multi_az               = false

  backup_retention_period  = var.environment == "prod" ? 7 : 1
  copy_tags_to_snapshot    = true
  delete_automated_backups = true
  skip_final_snapshot      = true

  auto_minor_version_upgrade   = true
  apply_immediately            = true
  deletion_protection          = false
  performance_insights_enabled = false

  enabled_cloudwatch_logs_exports = ["postgresql"]
}
