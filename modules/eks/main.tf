resource "aws_eks_cluster" "aws_eks" {
  name     = "${var.eks_name}-${terraform.workspace}"
  role_arn = var.eks_role_arn

  vpc_config {
    subnet_ids = var.private_subnets
  }
}
resource "aws_eks_node_group" "node" {
  cluster_name    = aws_eks_cluster.aws_eks.name
  node_group_name = "${var.eksnode_name}-${terraform.workspace}"
  node_role_arn   = var.eksnode_role_arn
  subnet_ids      = var.private_subnets
  instance_types  = var.instance_types
  tags = {
    "k8s.io/cluster-autoscaler/${aws_eks_cluster.aws_eks.name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled" = "TRUE"
  }
  scaling_config {
    desired_size = var.desirednode
    max_size     = var.maxnode
    min_size     = var.minnode
  }
  remote_access{
    ec2_ssh_key = var.keyname
  }
}