variable "project_name" {
  type        = string
  description = "Project name (used for naming resources)"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
}


variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
}

variable "ecs_service_name" {
  type        = string
  description = "Name of the ECS service managed by CodeDeploy"
}


variable "alb_listener_arn" {
  type        = string
  description = "ARN of the ALB listener that receives production traffic"
}

variable "target_group_blue_name" {
  type        = string
  description = "Name of the BLUE target group (current live version)"
}

variable "target_group_green_name" {
  type        = string
  description = "Name of the GREEN target group (new version)"
}


variable "deployment_config_name" {
  type        = string
  description = "CodeDeploy deployment strategy (AllAtOnce, Canary, Linear)"
}

variable "termination_wait_minutes" {
  type        = number
  description = "Minutes to wait before terminating BLUE tasks after success"
}

variable "test_listener_arn" {
  type        = string
  description = "ARN of the test ALB listener"
}
