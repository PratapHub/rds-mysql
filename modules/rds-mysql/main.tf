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

resource "aws_db_instance" "primary" {
  engine                  = "mysql"
  engine_version          = "5.7.30"
  instance_class          = "db.t3.medium"
  allocated_storage       = 20
  storage_type            = "gp2"
  name                    = var.name
  username                = var.username
  password                = data.vault_generic_secret.db_password.data.password
  parameter_group_name    = aws_db_parameter_group.mysql.name
  vpc_security_group_ids  = [aws_security_group.mysql.id]
  subnet_group_name       = aws_db_subnet_group.mysql.name
  multi_az                = true
  availability_zone       = var.primary_availability_zone
  tags                    = local.tags
}

resource "aws_db_instance" "secondary" {
  count                   = length(var.secondary_availability_zones)
  engine                  = "mysql"
  engine_version          = "5.7.30"
  instance_class          = "db.t3.medium"
  allocated_storage       = 20
  storage_type            = "gp2"
  name                    = "${var.name}-secondary-${count.index + 1}"
  username                = var.username
  password                = data.vault_generic_secret.db_password.data.password
  parameter_group_name    = aws_db_parameter_group.mysql.name
  vpc_security_group_ids  = [aws_security_group.mysql.id]
  subnet_group_name       = aws_db_subnet_group.mysql.name
  availability_zone       = element(var.secondary_availability_zones, count.index)
  tags                    = local.tags
}

resource "aws_db_instance_replica" "secondary" {
  count                   = length(var.secondary_availability_zones)
  source_db_instance_identifier = aws_db_instance.primary.id
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
