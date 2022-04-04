#Create main VPC in us-east-1
resource "aws_vpc" "main-vpc" {
  provider             = aws.region-main
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc-1"
  }
}

#Create main IGW in us-east-1
resource "aws_internet_gateway" "main-igw" {
  provider = aws.region-main
  vpc_id   = aws_vpc.main-vpc.id
  tags = {
    Name = "main-igw-1"
  }
}

# Create var.az_count private subnets, each in a different AZ
resource "aws_subnet" "private" {
  count             = var.az-count
  cidr_block        = cidrsubnet(aws_vpc.main-vpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  vpc_id            = aws_vpc.main-vpc.id
}

# Create var.az_count public subnets, each in a different AZ
resource "aws_subnet" "public" {
  count                   = var.az-count
  cidr_block              = cidrsubnet(aws_vpc.main-vpc.cidr_block, 8, var.az-count + count.index)
  availability_zone       = data.aws_availability_zones.azs.names[count.index]
  vpc_id                  = aws_vpc.main-vpc.id
  map_public_ip_on_launch = true
}

#Route public subnet traffic through IGW
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.main-vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main-igw.id
}

##Create NAT gateway with elastic IP for privat subnet to get internet_access
resource "aws_eip" "main-eip" {
  count      = var.az-count
  vpc        = true
  depends_on = [aws_internet_gateway.main-igw]
}

resource "aws_nat_gateway" "main-natgw" {
  count         = var.az-count
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.main-eip.*.id, count.index)
}

#Create route table for main-natgw through main-vpc
resource "aws_route_table" "private" {
  count  = var.az-count
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.main-natgw.*.id, count.index)
  }
}

#Overwrite default route table of subnets
resource "aws_route_table_association" "private" {
  count          = var.az-count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}