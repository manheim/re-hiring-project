terraform {
  required_version = ">= 0.11.8"
  backend "s3" {
    bucket = "cxhr-tfstate"
  }
}

provider "aws" {
  version = ">= 2.6.0"
  region  = "${var.region}"
}

provider "random" {
  version = "= 1.3.1"
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "${var.appname}-${var.environment}-eks-lt-${random_string.suffix.result}"
}

resource "aws_security_group" "worker_group_mgmt_one" {
  name_prefix = "worker_group_mgmt_one"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source         = "terraform-aws-modules/vpc/aws"
  version        = "1.60.0"
  name           = "${var.appname}-vpc-lt"
  cidr           = "10.0.0.0/16"
  azs            = ["${data.aws_availability_zones.available.names}"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway = true
  single_nat_gateway = true
  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "true"
  }
   public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
}

module "eks-cluster" {
  source               = "terraform-aws-modules/eks/aws"
  cluster_name         = "${local.cluster_name}"
  subnets              = ["${module.vpc.public_subnets}"]
  vpc_id               = "${module.vpc.vpc_id}"
  worker_group_count   = 1

  worker_groups = [
    {
      # name         = "worker-group-1"
      instance_type = "t1.micro"
      asg_max_size  = 5
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 3
      additional_security_group_ids = "${aws_security_group.worker_group_mgmt_one.id}"      
    }
  ]

  local_exec_interpreter = ["${var.local_shell}"]
  tags = {
    environment = "${var.appname}-${var.environment}-${var.region}"
  }
}
