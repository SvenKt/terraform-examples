resource "aws_subnet" "dev" {
  for_each =  { for key, value in var.subnets : key => value }

  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = "true"
  availability_zone       = each.value.az
  tags = {
    Name = join("_",[each.value.ns,each.key,each.value.az])
  }
}

resource "aws_route_table_association" "dev" {
  for_each =  { for key, value in var.subnets : key => value }

  subnet_id      = aws_subnet.dev[each.key].id
  route_table_id = var.route_table
}
