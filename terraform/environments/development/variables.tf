variable "availability_zones" {
  description = "Availability zones to use in us-east-1"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  description = "CIDR blocks for the public subnets in the dev VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "CIDR blocks for the private subnets in the dev VPC"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}
