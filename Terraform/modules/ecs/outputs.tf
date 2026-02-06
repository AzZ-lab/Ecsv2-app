output "service_name" {
  value = aws_ecs_service.app.name
}

output "service_arn" {
  value = aws_ecs_service.app.arn
}

output "cluster_id" {
  value = aws_ecs_cluster.ecs.id
}

output "cluster_name" {
  value = aws_ecs_cluster.ecs.name
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.app.arn
}
