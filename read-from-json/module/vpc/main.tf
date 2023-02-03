# vpc
resource "aws_vpc" "vpc_dev" {
  cidr_block           = var.vpc_data["cidr"]
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = join("_",[var.vpc_data["namespace"],"vpc"])
  }
}

resource "aws_internet_gateway" "gw_dev" {
  vpc_id = aws_vpc.vpc_dev.id

  tags = {
    Name = join("_",[var.vpc_data["namespace"],"igw"])
  }
}

#
# egress routing table
#

resource "aws_route_table" "rt_dev" {
  vpc_id = aws_vpc.vpc_dev.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_dev.id
  }

  tags = {
    Name = join("_",[var.vpc_data["namespace"],"rt"])
  }
}
