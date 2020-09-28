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