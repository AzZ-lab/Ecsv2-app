module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  aws_region   = var.aws_region
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

  private_subnet_ids          = module.vpc.private_subnet_ids
  ecs_tasks_security_group_id = module.alb.ecs_tasks_security_group_id
  target_group_blue_arn       = module.alb.target_group_blue_arn

  desired_count  = 1
  container_name = "app"
}

module "alb" {
  source = "./modules/alb"

  project_name = var.project_name
  environment  = var.environment

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids

  container_port    = var.container_port
  health_check_path = var.health_check_path
  alb_ingress_cidrs = ["0.0.0.0/0"]
  enable_https      = false
}
