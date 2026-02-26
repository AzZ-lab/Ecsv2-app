variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "container_port" {
  description = "Port your container listens on (e.g. 8000)"
  type        = number
}
variable "TABLE_NAME" {
  description = "DynamoDB table name used by the app"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}
variable "environment" {
  description = "The deployment environment (e.g. dev, staging, prod)"
  type        = string
}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "domain_name" {
  type = string
}

variable "deployment_config_name" {
  type        = string
  description = "CodeDeploy deployment strategy (AllAtOnce, Canary, Linear)"
}

variable "termination_wait_minutes" {
  type        = number
  description = "Minutes to wait before terminating BLUE tasks after success"
}

variable "image_uri" {
  type        = string
  description = "Full ECR image URI including tag (e.g. 123...amazonaws.com/repo:tag)"
}
