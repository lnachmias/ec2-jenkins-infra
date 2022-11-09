# Creates VPC
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = true
}

# Public Subnet
resource "aws_subnet" "public-subnet-1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_1_cidr
  availability_zone = "${var.region}a"
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

# Define the public route table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# Assign the public route table to the public subnet
resource "aws_route_table_association" "public-rt-association" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-rt.id
}

# Create Elastic IP for the EC2 instance
resource "aws_eip" "jenkins-eip" {
  vpc  = true
  tags = {
    Name = "jenkins-eip"
  }
}

# Associate Elastic IP to Linux Server
resource "aws_eip_association" "jenkins-eip-association" {
  instance_id   = aws_instance.jenkins.id
  allocation_id = aws_eip.jenkins-eip.id
}