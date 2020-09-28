
resource "aws_iam_role" "eks_nodegroup_role" {
  name = "${var.context.app_name}-eks_nodegroup_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodegroup_role.name
}

resource "aws_eks_node_group" "eks_nodegroup" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.context.app_name}-NodeGroup"
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids      = var.eks_cluster_settings.subnet_ids
  ami_type        = var.nodegroup_settings.ami_type
  disk_size       = var.nodegroup_settings.disk_size
  instance_types  = var.nodegroup_settings.instance_types


  scaling_config {
    desired_size = var.nodegroup_settings.desired_size
    max_size     = var.nodegroup_settings.max_size
    min_size     = var.nodegroup_settings.min_size
  }

  # Make sure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Else, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = merge(
    {
      Name = "${var.context.app_name}-NodeGroup",
      Environment = var.context.env_name
      Location = var.context.location
    },
    var.nodegroup_settings.custom_tags
  )
}
