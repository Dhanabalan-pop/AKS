output "eksrolearn" {
  description = "EKS cluster role"
  value       = aws_iam_role.eks_cluster.arn
  depends_on = [
    aws_iam_role_policy_attachmentpolicy.AmazonEKSClusterPolicy.id,
    aws_iam_role_policy_attachmentpolicy.AmazonEKSServicePolicy.id,
  ]
}
