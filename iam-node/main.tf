resource "aws_key_pair" "key" {
  key_name = var.keyname
  public_key = var.publickey
}
resource "aws_iam_role" "eks_cluster" {
  name = var.role_name
  assume_role_policy=var.assume_role_policy1
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = var.policy_arn3
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = var.policy_arn4
  role       = aws_iam_role.eks_cluster.name
}
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = var.policy_arn5
  role       = aws_iam_role.eks_cluster.name
}