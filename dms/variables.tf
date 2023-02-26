variable "dms_replication_instance_class" {
  type    = string
  default = "dms.t2.micro"
}

variable "dms_replication_security_group_id" {
  type    = string
  default = "sg-0123456789abcdef0"
}

variable "dms_source_endpoint_username" {
  type = string
}

variable "dms_source_endpoint_password" {
  type = string
}

variable "dms_source_endpoint_server_name" {
  type = string
}

variable "dms_source_endpoint_port" {
  type    = number
  default = 3306
}

variable "dms_source_endpoint_database_name" {
  type = string
}

variable "dms_target_endpoint_username" {
  type = string
}

variable "dms_target_endpoint_password" {
  type = string
}

variable "dms_target_endpoint_server_name" {
  type = string
}

variable "dms_target_endpoint_port" {
  type    = number
  default = 3306
}
