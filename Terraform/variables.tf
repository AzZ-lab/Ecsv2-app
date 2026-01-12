variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}
variable "image_uri" {
  description = "Full ECR image URI including tag (e.g. 123...amazonaws.com/repo:tag)"
  type        = string
}
variable "container_port" {
  description = "Port your container listens on (e.g. 8000)"
  type        = number
}
variable "dynamodb_table_name" {
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