 locals { 
  default_role_name = join("-", list(var.role_name, var.workspace ))
  }
resource "aws_iam_role" "eks_cluster" {
  #name = var.role_name
  name=local.default_role_name
  assume_role_policy=var.assume_role_policy
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = var.AmazonEKSClusterPolicy
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = var.AmazonEKSServicePolicy
  role       = aws_iam_role.eks_cluster.name
}