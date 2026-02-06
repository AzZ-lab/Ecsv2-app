variable "domain_name" {
  type = string
}

variable "alb_dns_name" {
  type        = string
  description = "ALB DNS name (e.g. xxx.eu-west-2.elb.amazonaws.com)"
}

variable "alb_zone_id" {
  type        = string
  description = "ALB hosted zone ID (from aws_lb.zone_id output)"
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}
