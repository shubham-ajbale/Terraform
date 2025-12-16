provider "aws" {
  region = "ap-south-1"
}

module "eks" {
  source = "./ProjectModule/EKS"

  eks_cluster_name       = "my-eks-cluster"
  eks_cluster_role_name = "eks-cluster-role"

  desired_size = var.desired_size
  min_size     = var.min_size
  max_size     = var.max_size
}