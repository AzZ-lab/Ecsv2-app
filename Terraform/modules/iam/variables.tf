variable "github_repo" {
  description = "The GitHub repository in the format 'owner/repo'"
  type        = string
  default = "AzZ-lab/Ecsv2-app"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "prod-ecs-v2"
}

variable "environment" {
  description = "The deployment environment"
  type        = string
  default     = "production"
}


variable "dynamodb_table_arn" {
  type        = string
  description = "ARN of the DynamoDB table used by the ECS task"
  default = "arn:aws:dynamodb:eu-west-2:663931958925:table/ecsv2-table"
}
