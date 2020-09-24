resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name = "${var.context.app_name}-IGW",
      Environment = var.context.env_name
      Location = var.context.location
    },
    var.vpc_settings.custom_tags
  )
}
/*
resource "aws_nat_gateway" "ngw" {
  
  count = length(var.subnet_settings.public_subnet_cidr_blocks)

  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = aws_subnet.public-sub[count.index].id

  tags = merge(
    {
      Name = "${var.context.app_name}-NGW-${count.index + 1}",
      Environment = var.context.env_name
      Location = var.context.location
    },
    var.vpc_settings.custom_tags
  )
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "eip" {
  count = length(var.subnet_settings.public_subnet_cidr_blocks)
  vpc = true
}
*/

resource "aws_eip" "eip" {
    vpc = true
}

resource "aws_nat_gateway" "ngw" {
  
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-sub[0].id

  tags = merge(
    {
      Name = "${var.context.app_name}-NGW",
      Environment = var.context.env_name
      Location = var.context.location
    },
    var.vpc_settings.custom_tags
  )
  depends_on = [aws_internet_gateway.igw]
}