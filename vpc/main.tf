resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = var.vpc_name
  }
}
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = var.ig_name
  }
}
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnets)
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones,   count.index)
  tags = {
    Name        = var.publicsubnet_name
    Tier = "Public"
    kubernetes.io/cluster/ekscluster-nine="shared"
    kubernetes.io/role/elb="1"
  }
}
resource "aws_route" "r" {
  route_table_id            = aws_vpc.vpc.main_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.ig.id
}
/* Private subnet */
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.private_subnets)
  cidr_block              = element(var.private_subnets, count.index)
  availability_zone       = element(var.availability_zones,   count.index)
  map_public_ip_on_launch = false
  tags = {
    Name        = "my-subnet-${count.index}-${var.workspace}"
    Tier = "Private"
    kubernetes.io/role/internal-elb = "1"
    kubernetes.io/cluster/ekscluster-nine="shared"
  }
}
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
  tags = {
    Name        = "my-nat-eip-${var.workspace}"
  }
}
/* NAT */
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  depends_on    = [aws_internet_gateway.ig]
  tags = {
    Name        = var.nat_name
  }
}
/* Routing table for private subnet */
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = var.routetable_name
  }
}
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}