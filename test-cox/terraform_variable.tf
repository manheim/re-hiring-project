variable "environment" {
  description = "The environment to deploy (e.g., dev, prod)"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy in"
  type        = string
  default     = "us-west-2"
}
