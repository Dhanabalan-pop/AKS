module "iam" {
source = "./iam"
role_name=var.eksclusterrole
workspace=var.workspace
assume_role_policy = var.role
policy_arn1=var.policy_arn1
policy_arn2=var.policy_arn2
}
module "iam-node" {
source = "./iam-node"
key_name = var.key_name
role_name=var.eksnoderole
workspace=var.workspace
policy_arn3=var.policy_arn3
policy_arn4=var.policy_arn4
policy_arn5=var.policy_arn5
assume_role_policy1 = var.role1
}
module "vpc" {
  source = "./vpc"
  vpc_name = join("-", list(var.vpc_name, var.workspace ))
  vpc_cidr = var.vpc_cidr
  ig_name=join("-", list(var.ig_name, var.workspace ))
  publicsubnet_name=join("-", list(var.publicsubnet_name, var.workspace ))
  public_subnets      = var.public_subnets_cidr
  availability_zones  = ["us-east-2a", "us-east-2b", "us-east-2c"]
  private_subnets     = var.private_subnets_cidr
  nat_name=join("-", list(var.nat_name, var.workspace ))
  routetable_name=join("-", list(var.routetable_name, var.workspace ))
  workspace=var.workspace
}
module "eks"{
  source="./eks"
  eks_role_arn = module.iam.eksrolearn
  eks_name=join("-", list(var.eks_name, var.workspace ))
  private_subnets = module.vpc.private_subnets_id
  eksnode_role_arn = module.iam-node.eksnoderolearn
  eksnode_name=join("-",list(var.eksnode_name, var.workspace))
  instance_types=var.instance_types
  minnode=var.minnode
  maxnode=var.maxnode
  desirednode=var.desirednode
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    module.iam-node.policy1,
    module.iam-node.policy2,
    module.iam-node.policy3,
  ]
}