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

  aws_region     = var.aws_region
  container_port = var.container_port
  table_name     = var.TABLE_NAME

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
  enable_https      = true

  certificate_arn = module.route53.certificate_arn
}

module "route53" {
  source = "./modules/route53"

  project_name = var.project_name
  environment  = var.environment
  domain_name  = var.domain_name

  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

module "waf" {
  source = "./modules/waf"

  project_name = var.project_name
  environment  = var.environment

  alb_arn = module.alb.alb_arn
}


module "codedeploy" {
  source = "./modules/codedeploy"

  project_name = var.project_name
  environment  = var.environment

  ecs_cluster_name = module.ecs.cluster_name
  ecs_service_name = module.ecs.service_name

  deployment_config_name   = var.deployment_config_name
  termination_wait_minutes = var.termination_wait_minutes

  alb_listener_arn        = module.alb.https_listener_arn
  target_group_blue_name  = module.alb.target_group_blue_name
  target_group_green_name = module.alb.target_group_green_name
}
