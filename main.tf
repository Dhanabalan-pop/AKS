module "iam" {
source = "./iam"
keyname = var.keypair
publickey = var.publickey
role_name=var.eksclusterrole
assume_role_policy = var.role
policy_arn1=var.policy_arn1
policy_arn2=var.policy_arn2
}
module "iam-node" {
source = "./iam-node"
keyname = var.keypair1
publickey = var.publickey
role_name=var.eksnoderole
policy_arn3=var.policy_arn3
policy_arn4=var.policy_arn4
policy_arn5=var.policy_arn5
assume_role_policy1 = var.role1
}
module "vpc" {
  source = "./vpc"
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
  ig_name=var.ig_name
  publicsubnet_name=var.publicsubnet_name
  public_subnets      = var.public_subnets_cidr
  availability_zones  = ["us-east-2a", "us-east-2b", "us-east-2c"]
  private_subnets     = var.private_subnets_cidr
  nat_name=var.nat_name
  routetable_name=var.routetable_name
  count= var.existingvpc =="true" ? 0:1
}
module "eks"{
  source="./eks"
  eks_role_arn = module.iam.eksrolearn
  eks_name=var.eks_name
  private_subnets     = var.existingvpc =="true"? var.existingsubnets:module.vpc.private_subnets_id
  eksnode_role_arn = module.iam-node.eksnoderolearn
  eksnode_name=var.eksnode_name
  instance_types=var.instance_types
  
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    module.iam-node.policy1,
    module.iam-node.policy2,
    module.iam-node.policy3,
  ]
}