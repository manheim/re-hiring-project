output "dev_vpc_id" {
  description = "The ID of the development VPC"
  value       = aws_vpc.dev_vpc.id
}

output "dev_public_subnet_ids" {
  description = "The IDs of the public subnets in the development VPC"
  value       = aws_subnet.dev_public_subnet.*.id
}

output "dev_private_subnet_ids" {
  description = "The IDs of the private subnets in the development VPC"
  value       = aws_subnet.dev_private_subnet.*.id
}
