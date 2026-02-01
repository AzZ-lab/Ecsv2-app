variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_region" {
  type        = string
  description = "AWS region for CloudWatch logs (e.g. eu-west-2)"
}

variable "image_uri" {
  type        = string
  description = "Full ECR image URI including tag (e.g. 123...amazonaws.com/repo:tag)"
}

variable "container_port" {
  type        = number
  description = "Port your container listens on (e.g. 8000)"
}


variable "execution_role_arn" {
  type        = string
  description = "ARN of ECS task execution role"
}

variable "task_role_arn" {
  type        = string
  description = "ARN of ECS task role (app permissions)"
}

variable "task_cpu" {
  type    = string
  default = "256"
}

variable "task_memory" {
  type    = string
  default = "512"
}

variable "log_retention_days" {
  type    = number
  default = 7
}

variable "dynamodb_table_name" {
  type        = string
  description = "ARN of the DynamoDB table used by the app"
}

variable "desired_count" {
  type        = number
  default     = 1
  description = "How many tasks to run"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnets for ECS tasks"
}

variable "ecs_tasks_security_group_id" {
  type        = string
  description = "Security group for ECS tasks (allows inbound from ALB only)"
}

variable "target_group_blue_arn" {
  type        = string
  description = "ALB blue target group ARN"
}

variable "container_name" {
  type        = string
  default     = "app"
  description = "Must match the container name in the ECS task definition"
}
