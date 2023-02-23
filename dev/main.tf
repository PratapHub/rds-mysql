module "rds_mysql" {
  source  = "./modules/rds-mysql"
  name    = var.name
  username = var.username
  password = var.password

  subnet_ids = data.aws_subnet_ids.all.ids

  primary_availability_zone = var.primary_availability_zone
  secondary_availability_zones = var.secondary_availability_zones
  region = var.primary_region

  replica {
    count = length(var.secondary_availability_zones)
    region = var.secondary_regions[count.index]
    availability_zone = var.secondary_availability_zones[count.index]
  }
}

data "aws_subnet_ids" "all" {
  vpc_id = var.vpc_id
}
