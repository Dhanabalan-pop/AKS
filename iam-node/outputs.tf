output "eksnoderolearn" {
  description = "EKS cluster node role"
  value       = aws_iam_role.eks_cluster.arn
}
output "policy1"{
    description = "EKS cluster node role policy1"
  value       = aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy
}
output "policy2"{
    description = "EKS cluster node role policy2"
  value       = aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy
}
output "policy3"{
    description = "EKS cluster node role policy3"
  value       = aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly
}