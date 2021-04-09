output "eksrolearn" {
  description = "EKS cluster role"
  value       = aws_iam_role.eks_cluster.arn
}
