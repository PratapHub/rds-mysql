output "rds_mysql_endpoint" {
  description = "The endpoint of the RDS MySQL instance"
  value       = aws_db_instance.rds_mysql.endpoint
}

output "rds_mysql_port" {
  description = "The port of the RDS MySQL instance"
  value       = aws_db_instance.rds_mysql.port
}

output "rds_mysql_username" {
  description = "The username for the RDS MySQL instance"
  value       = var.username
}

output "rds_mysql_password" {
  description = "The password for the RDS MySQL instance"
  value       = var.password
}

output "rds_mysql_primary_az" {
  description = "The availability zone of the primary RDS MySQL instance"
  value       = var.availability_zone
}

output "rds_mysql_secondary_azs" {
  description = "The list of availability zones for the secondary RDS MySQL instances"
  value       = var.secondary_availability_zones
}

output "rds_mysql_subnet_ids" {
  description = "The list of subnet IDs where RDS MySQL instance is launched"
  value       = aws_db_instance.rds_mysql.subnet_ids
}
