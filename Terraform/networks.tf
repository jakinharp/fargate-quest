#Create main VPC in us-east-1
resource "aws_vpc" "vpc-main" {
  provider             = aws.region-main
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-main-1"
  }
}

#Create main IGW in us-east-1
resource "aws_internet_gateway" "igw-main" {
  provider = aws.region-main
  vpc_id   = aws_vpc.vpc-main.id
  tags = {
    Name = "igw-main-1"
  }
}

#Create public subnet in us-east-1
resource "aws_subnet" "public-subnet" {
  provider          = aws.region-main
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc-main.id
  cidr_block        = "10.0.3.0/24"
  tags = {
    Name = "public-subnet-1"
  }
}

#Create private subnet in us-east-1
resource "aws_subnet" "private-subnet" {
  provider          = aws.region-main
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  vpc_id            = aws_vpc.vpc-main.id
  cidr_block        = "10.0.2.0/24"
  tags = {
    Name = "private-subnet-1"
  }
}

#Route public subnet traffic through IGW
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.vpc-main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw-main.id
}

##Create NAT gateway with elastic IP for privat subnet to get internet_access
resource "aws_eip" "main-eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw-main]
}

resource "aws_nat_gateway" "main-natgw" {
  subnet_id     = aws_subnet.public-subnet.id
  allocation_id = aws_eip.main-eip.id
}

# TODO: Create route table in region-main
# TODO: Overwrite default route table of vpc-main with new route table entries
