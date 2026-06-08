module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  environment  = var.environment
  services     = ["api", "dashboard", "worker"]
}

module "sg" {
  source = "./modules/sg"

  project_name               = var.project_name
  environment                = var.environment
  vpc_id                     = module.vpc.vpc_id
  allowed_alb_ingress_cidrs  = var.allowed_alb_ingress_cidrs
}

module "vpc_endpoints" {
  source = "./modules/vpc_endpoints"

  project_name           = var.project_name
  environment            = var.environment
  aws_region             = var.aws_region
  vpc_id                 = module.vpc.vpc_id
  private_subnet_ids     = module.vpc.private_subnet_ids
  private_route_table_id = module.vpc.private_route_table_id
  endpoint_sg_id         = module.sg.vpc_endpoint_sg_id
}

module "sqs" {
  source = "./modules/sqs"

  project_name = var.project_name
  environment  = var.environment
}

module "rds" {
  source = "./modules/rds"

  project_name       = var.project_name
  environment        = var.environment
  private_subnet_ids = module.vpc.private_subnet_ids
  rds_sg_id          = module.sg.rds_sg_id
  db_name            = var.db_name
  db_username        = var.db_username
  db_instance_class  = var.db_instance_class
}

module "redis" {
  source = "./modules/redis"

  project_name       = var.project_name
  environment        = var.environment
  private_subnet_ids = module.vpc.private_subnet_ids
  redis_sg_id        = module.sg.redis_sg_id
  node_type          = var.redis_node_type
}

module "iam" {
  source = "./modules/iam"

  project_name        = var.project_name
  environment         = var.environment
  aws_region          = var.aws_region
  github_repo         = var.github_repo
  github_branch       = var.github_branch
  sqs_queue_arn       = module.sqs.queue_arn
  rds_secret_arn      = module.rds.db_secret_arn
  ecr_repository_arns = module.ecr.repository_arns
}

module "alb" {
  source = "./modules/alb"

  project_name              = var.project_name
  environment               = var.environment
  vpc_id                    = module.vpc.vpc_id
  public_subnet_ids         = module.vpc.public_subnet_ids
  alb_sg_id                 = module.sg.alb_sg_id
  certificate_arn           = var.certificate_arn
  api_hostname              = var.api_hostname
  dashboard_hostname        = var.dashboard_hostname
}

module "waf" {
  source = "./modules/waf"

  project_name = var.project_name
  environment  = var.environment
  alb_arn      = module.alb.alb_arn
}

module "ecs" {
  source = "./modules/ecs"

  project_name                  = var.project_name
  environment                   = var.environment
  aws_region                    = var.aws_region
  private_subnet_ids            = module.vpc.private_subnet_ids
  ecs_sg_id                     = module.sg.ecs_sg_id
  execution_role_arn            = module.iam.ecs_task_execution_role_arn
  api_task_role_arn             = module.iam.api_task_role_arn
  worker_task_role_arn          = module.iam.worker_task_role_arn
  dashboard_task_role_arn       = module.iam.dashboard_task_role_arn
  api_image                     = "${module.ecr.repository_urls["api"]}:${var.container_image_tag}"
  dashboard_image               = "${module.ecr.repository_urls["dashboard"]}:${var.container_image_tag}"
  worker_image                  = "${module.ecr.repository_urls["worker"]}:${var.container_image_tag}"
  api_blue_target_group_arn     = module.alb.api_blue_target_group_arn
  dashboard_blue_target_group_arn = module.alb.dashboard_blue_target_group_arn
  api_desired_count             = var.api_desired_count
  dashboard_desired_count       = var.dashboard_desired_count
  worker_desired_count          = var.worker_desired_count
  sqs_queue_url                 = module.sqs.queue_url
  sqs_queue_name                = module.sqs.queue_name
  db_secret_arn                 = module.rds.db_secret_arn
  db_host                       = module.rds.db_endpoint
  db_name                       = var.db_name
  redis_endpoint                = module.redis.redis_endpoint
  db_username                   = var.db_username
  db_password                   = var.db_password

  depends_on = [module.vpc_endpoints, module.rds, module.redis]
}

module "codedeploy" {
  source = "./modules/codedeploy"

  project_name                    = var.project_name
  environment                     = var.environment
  codedeploy_role_arn             = module.iam.codedeploy_role_arn
  ecs_cluster_name                = module.ecs.cluster_name
  api_service_name                = module.ecs.api_service_name
  dashboard_service_name          = module.ecs.dashboard_service_name
  alb_listener_arn                = module.alb.https_listener_arn != "" ? module.alb.https_listener_arn : module.alb.http_listener_arn
  api_blue_target_group_name      = module.alb.api_blue_target_group_name
  api_green_target_group_name     = module.alb.api_green_target_group_name
  dashboard_blue_target_group_name  = module.alb.dashboard_blue_target_group_name
  dashboard_green_target_group_name = module.alb.dashboard_green_target_group_name

  depends_on = [module.ecs]
}
