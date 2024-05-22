resource "aws_ecs_task_definition" "hello_world" {
  family                   = "hello-world"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  container_definitions = jsonencode([{
    name      = "hello_world"
    image     = "YOUR_DOCKER_IMAGE"  # Replace with your Docker image URL
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
  }])
}

resource "aws_ecs_service" "hello_world_service" {
  name            = "hello-world-service"
  cluster         = aws_ecs_cluster.hello_world_cluster.id
  task_definition = aws_ecs_task_definition.hello_world.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["YOUR_SUBNETS"]  # Replace with your VPC subnets
    security_groups = ["YOUR_SECURITY_GROUP"]  # Replace with your security group
  }
}
