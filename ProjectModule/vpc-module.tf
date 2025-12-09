provider "aws" {
region = "ap-south-1"  
}

module "vpc" {
  source = "./modules/vpc"

  project                = var.project_module
  vpc_cidr_block         = var.cidr_block
  vpc_cidr_pub_subnet    = var.cidr_pub_subnet
  vpc_cidr_pri_subnet    = var.cidr_pri_subnet
}