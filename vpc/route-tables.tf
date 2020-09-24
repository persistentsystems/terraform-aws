
resource "aws_route_table" "privateRT" {
#  count = length(var.subnet_settings.private_subnet_cidr_blocks)

  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
     # Name = "${var.context.app_name}-PrivateRT-${count.index + 1}",
      Name = "${var.context.app_name}-PrivateRT",
      Environment = var.context.env_name
      Location = var.context.location
    },
    var.vpc_settings.custom_tags
  )
}

resource "aws_route" "private-route" {
#  count = length(var.subnet_settings.private_subnet_cidr_blocks)

  route_table_id         = aws_route_table.privateRT.id
  destination_cidr_block = "0.0.0.0/0"
#  nat_gateway_id         = aws_nat_gateway.ngw[count.index].id
  nat_gateway_id         = aws_nat_gateway.ngw.id
}

resource "aws_route_table" "publicRT" {
  
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name = "${var.context.app_name}-PublicRT",
      Environment = var.context.env_name
      Location = var.context.location
    },
    var.vpc_settings.custom_tags
  )
}

resource "aws_route" "public-route" {
  route_table_id         = aws_route_table.publicRT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}