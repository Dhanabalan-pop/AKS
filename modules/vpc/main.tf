#Vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "${var.vpc_name}-${terraform.workspace}"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.ig_name}-${terraform.workspace}"
  }
}

# public subnet
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones,   count.index)
  tags = {
    Name        = "${var.publicsubnet_name}-${terraform.workspace}"
    Tier = "Public"
    "kubernetes.io/cluster/${var.clustername}-${terraform.workspace}"="shared"
    "kubernetes.io/role/elb"="1"
  }
}

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    Name = "Default_public-${terraform.workspace}"
  }
}
# resource "aws_route_table" "public_rt" {
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.ig.id
#   }

#   tags = {
#     Name = "PublicSubnetRT-${terraform.workspace}"
#   }
# }

# Assign the route table to the public Subnet
resource "aws_route_table_association" "public-rt-association" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_default_route_table.default.id
}

/* Private subnet */
resource "aws_subnet" "private_subnet" {
  count                   = length(var.private_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.private_subnets, count.index)
  availability_zone       = element(var.availability_zones,   count.index)
  map_public_ip_on_launch = false
  tags = {
    Name        = "my-subnet-${count.index}-${var.workspace}"
    Tier = "Private"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.clustername}-${terraform.workspace}"="shared"
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
  subnet_id     = aws_subnet.public_subnet[0].id
  depends_on    = [aws_internet_gateway.ig]
  tags = {
    Name        = "${var.nat_name}-${terraform.workspace}"
  }
}

/* Routing table for private subnet */
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name        = "${var.routetable_name}-${terraform.workspace}"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
