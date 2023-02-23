locals {
  tags = merge(
    var.tags,
    {
      "Name" = var.name
    }
  )
}
data "vault_generic_secret" "db_password" {
  path = var.vault_path
}

resource "aws_rds_cluster_parameter_group" "cluster" {
  name_prefix = var.name
  family      = "aurora-mysql5.7"
  description = "A custom parameter group for Aurora MySQL 5.7"
  parameters  = {
    "character_set_client" = "utf8mb4"
  }
}

resource "aws_rds_cluster" "cluster" {
  cluster_identifier           = var.name
  engine                       = "aurora-mysql"
  engine_version               = "5.7.mysql_aurora.2.08.1"
  database_name                = "mydb"
  master_username              = var.username
  master_password              = data.vault_generic_secret.db_password.data.password
  backup_retention_period      = 7
  preferred_backup_window      = "07:00-09:00"
  backup_window                = "23:00-01:00"
  db_subnet_group_name         = aws_db_subnet_group.mysql.name
  vpc_security_group_ids       = [aws_security_group.mysql.id]
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.cluster.name
  tags                         = local.tags
}

resource "aws_rds_cluster_instance" "primary" {
  count                        = 1
  identifier                   = "${var.name}-primary"
  engine                       = "aurora-mysql"
  instance_class               = "db.t3.medium"
  db_subnet_group_name         = aws_db_subnet_group.mysql.name
  vpc_security_group_ids       = [aws_security_group.mysql.id]
  db_parameter_group_name      = aws_db_parameter_group.mysql.name
  availability_zone            = var.primary_availability_zone
  db_cluster_identifier        = aws_rds_cluster.cluster.id
  tags                         = local.tags
}

resource "aws_rds_cluster_instance" "secondary" {
  count                        = length(var.secondary_availability_zones)
  identifier                   = "${var.name}-secondary-${count.index + 1}"
  engine                       = "aurora-mysql"
  instance_class               = "db.t3.medium"
  db_subnet_group_name         = aws_db_subnet_group.mysql.name
  vpc_security_group_ids       = [aws_security_group.mysql.id]
  db_parameter_group_name      = aws_db_parameter_group.mysql.name
  availability_zone            = element(var.secondary_availability_zones, count.index)
  db_cluster_identifier        = aws_rds_cluster.cluster.id
  tags                         = local.tags
}


resource "aws_db_instance_replica" "secondary" {
  count                   = length(var.secondary_availability_zones)
  source_db_instance_identifier = aws_rds_cluster_instance.primary[0].id
  db_instance_class       = "db.t3.medium"
  auto_minor_version_upgrade = true
  availability_zone       = element(var.secondary_availability_zones, count.index)
}


resource "aws_security_group" "mysql" {
  name_prefix = "mysql"
  tags        = local.tags
}

resource "aws_db_subnet_group" "mysql" {
  name        = "mysql"
  subnet_ids  = var.subnet_ids
  tags        = local.tags
}

resource "aws_db_parameter_group" "mysql" {
  name = "mysql"
  family = "mysql5.7"
  parameter {
    name  = "max_connections"
    value = "100"
  }
}

output "primary_endpoint" {
  value = aws_db_instance.primary.endpoint
}

output "secondary_endpoints" {
  value = [for i, az in var.secondary_availability_zones : aws_db_instance_replica.secondary[i].endpoint]
}
