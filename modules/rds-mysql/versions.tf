terraform {
  required_version = ">= 0.13"
}

provider "aws" {
  region = var.region
  version = "~> 2.0"
}

resource "aws_db_subnet_group" "rds_mysql_subnet_group" {
  name       = var.name
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "rds_mysql_sg" {
  name_prefix = "${var.name}-"
  vpc_id      = var.vpc_id
}

resource "aws_db_instance" "rds_mysql" {
  name             = var.name
  engine           = var.engine
  engine_version   = var.engine_version
  instance_class   = var.instance_class
  allocated_storage = var.allocated_storage
  username         = var.username
  password         = var.password
  db_subnet_group_name  = aws_db_subnet_group.rds_mysql_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_mysql_sg.id]
  multi_az         = var.multi_az
  backup_retention_period = var.backup_retention_period
  maintenance_window = var.maintenance_window
  tags             = var.tags

  availability_zone = var.availability_zone

  secondary_availability_zones = var.secondary_availability_zones
}
