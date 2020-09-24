
resource "aws_iam_role" "eks_control_plane_role" {
  name = "${var.context.app_name}-eks_control_plane_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_control_plane_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_control_plane_role.name
}


resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.context.app_name}-eks_cluster"
  role_arn = aws_iam_role.eks_control_plane_role.arn
  enabled_cluster_log_types = ["api", "audit"]
  depends_on = [aws_cloudwatch_log_group.eks_logging]

  vpc_config {
    subnet_ids = var.eks_cluster_settings.subnet_ids
    endpoint_private_access = true
    endpoint_public_access = true
    public_access_cidrs = var.eks_cluster_settings.public_access_cidrs

  }

  tags = merge(
    {
      Name = "${var.context.app_name}-eks_cluster",
      Environment = var.context.env_name
      Location = var.context.location
    },
    var.eks_cluster_settings.custom_tags
  )
}
