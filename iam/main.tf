resource "aws_iam_role" "eks_cluster" {
  name = var.role_name
  assume_role_policy=var.assume_role_policy
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = var.policy_arn1
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = var.policy_arn2
  role       = aws_iam_role.eks_cluster.name
}