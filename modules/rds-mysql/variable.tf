variable "name" {
  description = "The name of the RDS MySQL instance"
  type        = string
}

variable "username" {
  description = "The username for the RDS MySQL instance"
  type        = string
}

variable "password" {
  description = "The password for the RDS MySQL instance"
  type        = string
}

variable "availability_zone" {
  description = "The availability zone for the primary RDS MySQL instance"
  type        = string
}

variable "secondary_availability_zones" {
  description = "The list of availability zones for the secondary RDS MySQL instances"
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "The list of subnet IDs where RDS MySQL instance should be launched"
  type        = list(string)
}

variable "allocated_storage" {
  description = "The amount of storage to allocate for the RDS MySQL instance (in gigabytes)"
  type        = number
  default     = 20
}

variable "engine" {
  description = "The database engine to use for the RDS MySQL instance"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "The version of the database engine to use for the RDS MySQL instance"
  type        = string
  default     = "5.7"
}

variable "instance_class" {
  description = "The instance class to use for the RDS MySQL instance"
  type        = string
  default     = "db.t2.micro"
}

variable "multi_az" {
  description = "Specifies if the RDS MySQL instance is a Multi-AZ deployment"
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "The number of days to retain backups for the RDS MySQL instance"
  type        = number
  default     = 7
}

variable "maintenance_window" {
  description = "The maintenance window for the RDS MySQL instance"
  type        = string
  default     = "Mon:00:00-Mon:03:00"
}

variable "tags" {
  description = "A map of tags to assign to the RDS MySQL instance"
  type        = map(string)
  default     = {}
}

