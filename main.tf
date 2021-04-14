data "aws_availability_zones" "azs" {}

# module "iam" {
#   source             = "./modules/iam"
#   role_name          = var.eksclusterrole
#   workspace          = var.workspace
#   assume_role_policy = var.role
#   AmazonEKSClusterPolicy        = var.AmazonEKSClusterPolicy
#   AmazonEKSServicePolicy        = var.AmazonEKSServicePolicy
# }
# module "iam-node" {
#   source              = "./modules/iam-node"
#   key_name            = var.key_name
#   role_name           = var.eksnoderole
#   workspace           = var.workspace
#   AmazonEKSWorkerNodePolicy         = var.AmazonEKSWorkerNodePolicy
#   AmazonEKS_CNI_Policy         = var.AmazonEKS_CNI_Policy
#   AmazonEC2ContainerRegistryReadOnly         = var.AmazonEC2ContainerRegistryReadOnly
#   assume_role_policy1 = var.role1
# }
module "vpc" {
  source             = "./modules/vpc"
  vpc_name           = var.vpc_name
  clustername        = var.eks_name
  vpc_cidr           = var.vpc_cidr
  ig_name            = var.ig_name
  publicsubnet_name  = var.publicsubnet_name
  public_subnets     = var.public_subnets_cidr
  availability_zones = data.aws_availability_zones.azs.names
  private_subnets    = var.private_subnets_cidr
  nat_name           = var.nat_name
  routetable_name    = var.routetable_name
  workspace          = var.workspace
  # count              = var.existingvpc == "true" ? 0 : 1
}
# module "eks" {
#   source           = "./modules/eks"
#   eks_role_arn     = module.iam.eksrolearn  
#   eks_name         = var.eks_name
#   private_subnets  = var.existingvpc == "false" ? module.vpc[0].private_subnets_id : var.existingsubnets
#   #private_subnets = module.vpc.private_subnets_id
#   eksnode_role_arn = module.iam-node.eksnoderolearn
#   eksnode_name     = var.eksnode_name
#   instance_types   = var.instance_types
#   minnode          = var.minnode
#   maxnode          = var.maxnode
#   desirednode      = var.desirednode
#   keyname          = module.iam-node.keyname
#   # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
#   # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
#   depends_on = [
#     module.iam-node.policy1,
#     module.iam-node.policy2,
#     module.iam-node.policy3,
#   ]
# }