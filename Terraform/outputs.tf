output "codedeploy_app_name" {
  value = module.codedeploy.codedeploy_app_name
}

output "codedeploy_deployment_group_name" {
  value = module.codedeploy.deployment_group_name
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "ecs_service_name" {
  value = module.ecs.service_name
}



output "container_name" {
  value = "app"
}

output "container_port" {
  value = var.container_port
}
