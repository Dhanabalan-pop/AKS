output "EKSclustername" {
value=aws_eks_cluster.aws_eks.name
}
output "EKSclusterautoscalerrole"{
    value=aws_eks_role.example.arn
}