terraform {
  required_version = ">= 1.12.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.9.0"
    }
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags = merge(var.tags, {
    Name = "[${var.tags.Project}] ${var.name}"
  })
}

# Create an Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags, {
    Name = "[${var.tags.Project}] ${var.name}"
  })
}

# Create private subnets
resource "aws_subnet" "private_subnets" {
  vpc_id            = aws_vpc.main.id
  count             = length(var.private_subnet_cidrs)
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = element(data.aws_availability_zones.available.names, count.index % length(data.aws_availability_zones.available.names))
  tags = merge(var.tags, {
    Name = "[${var.tags.Project}] private-${count.index}"
  })
}

# Create public subnets
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index % length(data.aws_availability_zones.available.names))
  map_public_ip_on_launch = true
  tags = merge(var.tags, {
    Name = "[${var.tags.Project}] public-${count.index}"
  })
}

# Create a public route table
resource "aws_route_table" "internet" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = aws_vpc.main.cidr_block
    gateway_id = "local"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = merge(var.tags, {
    Name = "[${var.tags.Project}] internet"
  })
}

# Assosiate all public subnets with public route table
resource "aws_route_table_association" "public_rtas" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.internet.id
}
