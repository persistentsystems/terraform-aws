output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_certificat_authority" {
  value = aws_eks_cluster.eks_cluster.certificate_authority 
}