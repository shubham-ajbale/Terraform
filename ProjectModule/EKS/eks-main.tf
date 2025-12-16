provider "aws" {
    region = "ap-south-1"
  
}

# IAM Role-EKS cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = var.eks_cluster_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "eks.amazonaws.com"
          ]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}


# Data block for default vpc and subnet

data "aws_vpc" "default_vpc" {
    default = true 
  
}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
  filter {
    name   = "availability-zone"
    values = ["apt-south-1a", "ap-south-1b", "ap-south-1c"]
}
}


# Cluster 
resource "aws_eks_cluster" "eks_cluster" {
  name = var.eks_cluster_name

  access_config {
    authentication_mode = var.mode
  }

  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.34"

  vpc_config {
  subnet_ids = data.aws_subnets.default_subnets.ids
}

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}


# IAM role for Node Group 

resource "aws_iam_role" "eks_cluster_node_role" {
  name = "eks-role-node-group"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sts:AssumeRole"
        ]
        Principal = {
          Service = [
            "ec2.amazonaws.com"
          ]
        }
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "AmazonEC2_ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_cluster_node_role.name
}

resource "aws_iam_role_policy_attachment" "Amazon_EKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_cluster_node_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_WorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_cluster_node_role.name
}


# Node-group

resource "aws_eks_node_group" "eks_node" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "my-nodes"
  node_role_arn   = aws_iam_role.eks_cluster_node_role.arn
  subnet_ids = data.aws_subnets.default_subnets.ids
  scaling_config {
    desired_size = var.dz
    max_size     = var.maxs
    min_size     = var.mins
  }

  update_config {
    max_unavailable = var.maxu
  }

  
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEC2_ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.Amazon_EKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEKS_WorkerNodePolicy,
  ]
}