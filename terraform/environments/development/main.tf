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
  security_groups    = [aws_security_group.dev_alb_sg_frontend.id]
  subnets            = aws_subnet.dev_public_subnet[*].id

  enable_deletion_protection = false

  tags = {
    Name = "dev-alb-frontend"
  }
}

resource "aws_lb" "dev_alb_backend" {
  name               = "dev-alb-backend"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.dev_alb_sg_backend.id]
  subnets            = aws_subnet.dev_private_subnet[*].id

  enable_deletion_protection = false

  tags = {
    Name = "dev-alb-backend"
  }
}

resource "aws_db_instance" "dev_rds" {
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  username = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)["username"]
  password = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)["password"]
  db_subnet_group_name = aws_db_subnet_group.dev_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.dev_rds_sg.id]
}

data "aws_secretsmanager_secret" "db_credentials" {
  name = "dev-rds-password"
}

data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = data.aws_secretsmanager_secret.db_credentials.id
}

resource "aws_db_subnet_group" "dev_db_subnet_group" {
  name       = "dev-db-subnet-group"
  subnet_ids = aws_subnet.dev_private_subnet[*].id

  tags = {
    Name = "dev-db-subnet-group"
  }
}

resource "aws_security_group" "dev_rds_sg" {
  vpc_id = aws_vpc.dev_vpc.id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.dev_alb_sg_backend.id]
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
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups = [aws_security_group.dev_alb_sg_frontend.id]
  }
#todo: update the cidr block with backend service
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  tags = {
    Name = "dev-alb-sg-backend"
  }
}
