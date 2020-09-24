output "vpc-id" {
  value       = aws_vpc.vpc.id
  description = "VPC ID"
}

output "public_subnet_ids" {
  value       = aws_subnet.public-sub.*.id
  description = "List of public subnet IDs"
}

output "private_subnet_ids" {
  value       = aws_subnet.private-sub.*.id
  description = "List of private subnet IDs"
}
/*
output "cidr_block" {
  value       = merge(tolist(var.vpc_settings.cidr_block), var.vpc_settings.additional_cidr_blocks)
  description = "The CIDR block associated with the VPC"
}
*/
output "nat_gateway_ips" {
  value       = aws_eip.eip.*.public_ip
  description = "List of Elastic IPs associated with NAT gateways"
}