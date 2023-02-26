# Create a replication instance in AWS DMS
resource "aws_dms_replication_instance" "dms" {
  allocated_storage         = 20
  engine_version            = "3.3.3"
  replication_instance_class = var.dms_replication_instance_class
  replication_instance_id   = "dms-replication-instance"
  vpc_security_group_ids    = [var.dms_replication_security_group_id]
  availability_zone         = "ca-central-1a"
  replication_instance_role_arn = aws_iam_role.dms_replication_instance_role.arn
  multi_az                  = false
  engine_name               = "aurora"
  publicly_accessible       = false
  tags = {
    Name = "dms-replication-instance"
  }
}

# Create source and target endpoints in AWS DMS
resource "aws_dms_endpoint" "source" {
  endpoint_identifier = "source-endpoint"
  endpoint_type       = "source"
  engine_name         = "mariadb"
  username            = var.dms_source_endpoint_username
  password            = var.dms_source_endpoint_password
  server_name         = var.dms_source_endpoint_server_name
  port                = var.dms_source_endpoint_port
  database_name       = var.dms_source_endpoint_database_name
}

resource "aws_dms_endpoint" "target" {
  endpoint_identifier = "target-endpoint"
  endpoint_type       = "target"
  engine_name         = "aurora"
  username            = var.dms_target_endpoint_username
  password            = var.dms_target_endpoint_password
  server_name         = var.dms_target_endpoint_server_name
  port                = var.dms_target_endpoint_port
}

# Create a replication task in AWS DMS to migrate data from the on-prem MariaDB database to the RDS Aurora MySQL instance
resource "aws_dms_replication_task" "dms" {
  replication_task_id            = "dms-replication-task"
  migration_type                 = "full-load"
  source_endpoint_arn            = aws_dms_endpoint.source.arn
  target_endpoint_arn            = aws_dms_endpoint.target.arn
  replication_instance_arn       = aws_dms_replication_instance.dms.arn
  table_mappings                 = file("${path.module}/table-mappings.json")
  cdc_start_time                 = "0"
  replication_task_settings      = jsonencode({
    targetMetadata = "aurora-mysql",
    fullLoadSettings = {
      targetTablePrepMode = "DROP_AND_CREATE",
      createPkAfterFullLoad = true
    }
  })
  tags = {
    Name = "dms-replication-task"
  }
}

# Output the replication task ARN
output "replication_task_arn" {
  value = aws_dms_replication_task.dms.arn
}
