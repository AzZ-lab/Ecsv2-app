resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project_name}-${var.environment}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${var.project_name}-${var.environment}"
  retention_in_days = var.log_retention_days

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project_name}-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory

  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "app"
      image     = var.image_uri          # <-- FILL THIS (ECR image URI)
      essential = true

      portMappings = [
        {
          containerPort = var.container_port  # <-- FILL THIS (e.g. 8000)
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "DYNAMODB_TABLE_NAME"
          value = var.dynamodb_table_name     # <-- FILL THIS (table name)
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.app.name
          awslogs-region        = var.aws_region  # <-- FILL THIS (region)
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}
