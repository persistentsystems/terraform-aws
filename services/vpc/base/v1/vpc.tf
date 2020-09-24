
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_settings.cidr_block
  instance_tenancy     = var.vpc_settings.instance_tenancy
  enable_dns_support   = true
  enable_dns_hostnames = true
  assign_generated_ipv6_cidr_block = var.vpc_settings.enable_ipv6

  tags = merge(
    {
      Name = "${var.context.app_name}-VPC",
      Environment = var.context.env_name
      Location = var.context.location
    },
    var.vpc_settings.custom_tags
  )
}

resource "aws_vpc_ipv4_cidr_block_association" "cidr_assoc" {
  
  count = length(var.vpc_settings.additional_cidr_blocks)
  vpc_id = aws_vpc.vpc.id

  cidr_block = element(var.vpc_settings.additional_cidr_blocks, count.index)

}