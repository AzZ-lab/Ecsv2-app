variable "project_name" {
  type        = string
  description = "Project name used for tagging and naming"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
}

variable "alb_arn" {
  type        = string
  description = "ARN of the Application Load Balancer to protect"
}
