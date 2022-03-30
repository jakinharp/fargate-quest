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

#Create public subnet in us-east-1
resource "aws_subnet" "public-subnet" {
  provider          = aws.region-main
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = "10.0.3.0/24"
  tags = {
    Name = "public-subnet-1"
  }
}

#Create private subnet in us-east-1
resource "aws_subnet" "private-subnet" {
  provider          = aws.region-main
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = "10.0.2.0/24"
  tags = {
    Name = "private-subnet-1"
  }
}

#Route public subnet traffic through IGW
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.main-vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main-igw.id
}

##Create NAT gateway with elastic IP for privat subnet to get internet_access
resource "aws_eip" "main-eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.main-igw]
}

resource "aws_nat_gateway" "main-natgw" {
  subnet_id     = aws_subnet.public-subnet.id
  allocation_id = aws_eip.main-eip.id
}

#Create route table for main-natgw through main-vpc
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main-natgw.id
  }
}

# TODO: Overwrite default route table of main-vpc with new route table entries
