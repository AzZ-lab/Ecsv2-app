output "container_name" {
  value       = "app"
  description = "The name of the ECS container"
}

output "container_port" {
  value       = var.container_port
  description = "The port the container listens on"
}
