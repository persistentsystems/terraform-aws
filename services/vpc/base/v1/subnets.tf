
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "private-sub" {
  count = length(var.subnet_settings.private_subnet_cidr_blocks)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_settings.private_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    {
      Name = "${var.context.app_name}-PrivateSub-${count.index + 1}",
      Environment = var.context.env_name
      Location = var.context.location
    },
    var.vpc_settings.custom_tags,
    var.vpc_settings.priv-sub_custom_tags
  )
}

resource "aws_route_table_association" "private-rt-assoc" {
  count = length(var.subnet_settings.private_subnet_cidr_blocks)

  subnet_id      = aws_subnet.private-sub[count.index].id
  route_table_id = aws_route_table.privateRT.id
}

resource "aws_subnet" "public-sub" {
  count = length(var.subnet_settings.public_subnet_cidr_blocks)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_settings.public_subnet_cidr_blocks[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = "${var.context.app_name}-PublicSub-${count.index + 1}",
      Environment = var.context.env_name
      Location = var.context.location
    },
    var.vpc_settings.custom_tags,
    var.vpc_settings.pub-sub_custom_tags
  )
}

resource "aws_route_table_association" "public-rt-assoc" {
  count = length(var.subnet_settings.public_subnet_cidr_blocks)

  subnet_id      = aws_subnet.public-sub[count.index].id
  route_table_id = aws_route_table.publicRT.id
}