<<<<<<< HEAD
# output "public_key" {
#   value = module.iam-node.public_key
# }
# output "private_key" {
#   value = module.iam-node.private_key
# }
=======
output "public_key" {
  value = module.iam-node.public_key
}

output "private_key" {
  value = module.iam-node.private_key
    
output EKSclustername{
    value=module.eks.EKSclustername
}
>>>>>>> 37b268dde1b050b1c533d558eb6b78144cc26fd3
