output "eksnoderolearn" {
  description = "EKS cluster node role"
  value       = aws_iam_role.eks_cluster.arn
  depends_on = [
    policy1,
    policy2,
    policy3,
  ]
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
output "public_key"{
  value = tls_private_key.example.public_key_openssh
  }
output "private_key"{
  value = tls_private_key.example.private_key_pem
  }
output "keyname"{
value = aws_key_pair.generated_key.key_name
}