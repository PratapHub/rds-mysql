variable "name" {
  type        = string
  description = "The name of the RDS MySQL instance"
}

variable "username" {
  type        = string
  description = "The username for the RDS MySQL instance"
}

variable "password" {
  type        = string
  description = "The password for the RDS MySQL instance"

  # Use Terraform Vault to securely manage the password
#   sensitive = true
#   default   = vault("YOUR_PATH_secret/data/rds/mysql_password") 
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC to launch the RDS MySQL instance in"
}

variable "primary_availability_zone" {
  type        = string
  description = "The availability zone of the primary RDS MySQL instance"
}

variable "secondary_availability_zones" {
  type        = list(string)
  description = "The list of availability zones for the secondary RDS MySQL instances"
}

variable "region" {
  type        = string
  description = "The AWS region to launch the RDS MySQL instance in"
}
