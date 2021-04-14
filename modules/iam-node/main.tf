  locals { 
  default_role_name = join("-", list(var.role_name, var.workspace ))
  default_key_name = join("-", list(var.key_name, var.workspace ))
  }
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "generated_key" {
  key_name   = local.default_key_name
  public_key = tls_private_key.example.public_key_openssh
}
resource "aws_iam_role" "eks_cluster" {
  #name = var.role_name
   name = local.default_role_name
  assume_role_policy=var.assume_role_policy1
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = var.AmazonEKSWorkerNodePolicy
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = var.AmazonEKS_CNI_Policy
  role       = aws_iam_role.eks_cluster.name
}
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = var.AmazonEC2ContainerRegistryReadOnly
  role       = aws_iam_role.eks_cluster.name
}