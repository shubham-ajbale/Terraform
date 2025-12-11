provider "aws" {
region = "ap-south-1"  
}

module "alb_terraform" {
  source = "./ProjectModule/ALB"

  load_balancer_type = var.lb_type
}