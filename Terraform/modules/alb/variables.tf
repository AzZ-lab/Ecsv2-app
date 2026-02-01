variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnets for the ALB"
}

variable "container_port" {
  type        = number
  description = "Port the app container listens on"
}

variable "health_check_path" {
  type        = string
  default     = "/health"
  description = "Health check endpoint path on your app"
}

variable "alb_ingress_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "Who can access the ALB (lock down later if desired)"
}

variable "enable_https" {
  type    = bool
  default = false
}
