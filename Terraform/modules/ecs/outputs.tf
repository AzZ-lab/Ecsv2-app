output "service_name" {
  value = aws_ecs_service.app.name
}

output "service_arn" {
  value = aws_ecs_service.app.arn
}

output "cluster_id" {
  value = aws_ecs_cluster.ecs.id
}
