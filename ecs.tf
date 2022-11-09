resource "aws_security_group" "app_SG" {
  name        = "app_SG"
  description = "Allows Port 80 to access application"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP Port"
    from_port   = 80
    to_port     = 80
    self        = "false"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_ecs_cluster" "app_cluster" {
  name = "app_cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
} 
 
resource "aws_ecs_task_definition" "task" {
  family                   = "service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE", "EC2"]
  cpu                      = 512
  memory                   = 2048
  execution_role_arn       = "arn:aws:iam::384027570195:role/ECS-essential"
  container_definitions    = <<DEFINITION
  [
    {
      "name"      : "app-container",
      "image"     : "384027570195.dkr.ecr.us-east-1.amazonaws.com/main-repo:latest",
      "cpu"       : 512,
      "memory"    : 2048,
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : 80,
          "hostPort"      : 80
        }
      ]
    }
  ]
  DEFINITION
}

resource "aws_ecs_service" "service" {
  name             = "service"
  cluster          = aws_ecs_cluster.app_cluster.id
  task_definition  = aws_ecs_task_definition.task.id
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.app_SG.id]
    subnets          = [aws_subnet.public-subnet-1.id]
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
} 
