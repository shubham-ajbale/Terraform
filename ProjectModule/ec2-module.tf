provider "aws" {
region = "ap-south-1"  
}

module "ec2_terraform" {
  source = "./ProjectModule/EC2"
  
  instance_type = var.instance_type_ec2
  ami_id        = var.ami_id
  
}