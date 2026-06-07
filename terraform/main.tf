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
