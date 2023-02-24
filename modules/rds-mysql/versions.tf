terraform {
  required_version = ">= 0.14"
  required_providers {
    aws = ">= 2.0"
  }
}

provider "aws" {
  region = var.region
}

