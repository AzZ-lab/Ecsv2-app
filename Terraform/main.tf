module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name

  aws_region = var.aws_region
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
  environment  = var.environment
}


module "ecs" {
  source = "./modules/ecs"

  project_name = var.project_name
  environment  = var.environment

  aws_region          = var.aws_region
  image_uri           = var.image_uri
  container_port      = var.container_port
  dynamodb_table_name = var.dynamodb_table_name

  execution_role_arn = module.iam.ecs_execution_role_arn
  task_role_arn      = module.iam.ecs_task_role_arn
}
