resource "aws_eks_cluster" "aws_eks" {
  name     = "${var.eks_name}-${terraform.workspace}"
  role_arn = var.eks_role_arn

  vpc_config {
    subnet_ids = var.private_subnets
  }
}
data "tls_certificate" "example" {
  url = aws_eks_cluster.aws_eks.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "example" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.example.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.aws_eks.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "example_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.example.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.example.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "example" {
  assume_role_policy = data.aws_iam_policy_document.example_assume_role_policy.json
  name               = "example"
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