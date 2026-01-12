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

variable "dynamodb_table_name" {
  type        = string
  description = "DynamoDB table name used by the app"
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
