# 1. Create the VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.env_name}-vpc"
    Environment = var.env_name
  }
}

# 2. Create an Internet Gateway so resources can talk to the internet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env_name}-igw"
  }
}

# 3. Create Public Subnet 1 (Zone A)
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "ap-south-1a" # Explicitly force to Availability Zone A
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env_name}-public-subnet-1"
  }
}

# NEW: Create Public Subnet 2 (Zone B) to satisfy Multi-AZ RDS requirement
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 2) # Automatically maps a safe, non-overlapping subnet IP range
  availability_zone       = "ap-south-1b" # Force to a completely different Availability Zone (Zone B)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env_name}-public-subnet-2"
  }
}

# 4. Create a Route Table to direct traffic out to the internet
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.env_name}-public-rt"
  }
}

# 5. Associate the route table with Public Subnet 1
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt.id
}

# NEW: Associate the route table with Public Subnet 2
resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.rt.id
}