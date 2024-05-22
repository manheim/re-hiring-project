provider "aws" {
  region = "us-west-2"
}

resource "aws_ecs_cluster" "hello_world_cluster" {
  name = "hello-world-cluster"
}

module "ecs_service" {
  source = "./ecs_task_definition.tf"
  cluster = aws_ecs_cluster.hello_world_cluster.id
  environment = var.environment
}
