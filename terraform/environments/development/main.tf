provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "dev_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "dev-vpc"
  }
}

resource "aws_subnet" "dev_public_subnet" {
  count = length(var.public_subnets)

  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "dev-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "dev_private_subnet" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = var.private_subnets[count.index]
  map_public_ip_on_launch = false
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "dev-private-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "dev_public_rt" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_igw.id
  }

  tags = {
    Name = "dev-public-rt"
  }
}

resource "aws_route_table_association" "dev_public_rta" {
  count = length(aws_subnet.dev_public_subnet)

  subnet_id      = aws_subnet.dev_public_subnet[count.index].id
  route_table_id = aws_route_table.dev_public_rt.id
}

resource "aws_lb" "dev_alb_frontend" {
  name               = "dev-alb-frontend"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.dev_alb_sg.id]
  subnets            = aws_subnet.dev_public_subnet[*].id

  enable_deletion_protection = false

  tags = {
    Name = "dev-alb"
  }
}

resource "aws_lb" "dev_alb_backend" {
  name               = "dev-alb-backend"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.dev_alb_sg.id]
  subnets            = aws_subnet.dev_private_subnet[*].id

  enable_deletion_protection = false

  tags = {
    Name = "dev-alb"
  }
}

resource "aws_security_group" "dev_alb_sg_frontend" {
  name        = "dev-alb-sg-frontend"
  description = "Security group for the frontend dev ALB"

  vpc_id = aws_vpc.dev_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev-alb-sg-frontend"
  }
}

resource "aws_security_group" "dev_alb_sg_backend" {
  name        = "dev-alb-sg-backend"
  description = "Security group for the backend dev ALB"

  vpc_id = aws_vpc.dev_vpc.id
#todo: update the cidr block with backend service
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
#todo: update the cidr block with backend service
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev-alb-sg-backend"
  }
}
