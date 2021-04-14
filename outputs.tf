output "public_key" {
  value = module.iam-node.public_key
}

output "private_key" {
  value = module.iam-node.private_key
}
output EKSclustername{
    value=module.eks.EKSclustername
}