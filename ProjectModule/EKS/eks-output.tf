output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS Kubernetes API server"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.arn
}

output "eks_cluster_version" {
  description = "Kubernetes version of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.version
}

output "eks_cluster_security_group_id" {
  description = "Security group associated with the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
}

output "eks_node_group_name" {
  description = "Name of the EKS node group"
  value       = aws_eks_node_group.eks_node.node_group_name
}

output "eks_node_group_arn" {
  description = "ARN of the EKS node group"
  value       = aws_eks_node_group.eks_node.arn
}

output "eks_node_group_status" {
  description = "Status of the EKS node group"
  value       = aws_eks_node_group.eks_node.status
}

output "eks_cluster_role_arn" {
  description = "IAM role ARN used by the EKS cluster"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_role_arn" {
  description = "IAM role ARN used by EKS worker nodes"
  value       = aws_iam_role.eks_cluster_node_role.arn
}

output "vpc_id" {
  description = "VPC ID used by the EKS cluster"
  value       = data.aws_vpc.default_vpc.id
}

output "subnet_ids" {
  description = "Subnets used by the EKS cluster and node group"
  value       = data.aws_subnets.default_subnets.ids
}