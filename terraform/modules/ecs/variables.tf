variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for ECS services"
  type        = list(string)
}

variable "ecs_sg_id" {
  description = "Security group attached to ECS tasks"
  type        = string
}

variable "execution_role_arn" {
  description = "ECS task execution role ARN"
  type        = string
}

variable "api_task_role_arn" {
  description = "IAM role for API task"
  type        = string
}

variable "worker_task_role_arn" {
  description = "IAM role for Worker task"
  type        = string
}

variable "dashboard_task_role_arn" {
  description = "IAM role for Dashboard task"
  type        = string
}

variable "api_image" {
  description = "API container image URI"
  type        = string
}

variable "dashboard_image" {
  description = "Dashboard container image URI"
  type        = string
}

variable "worker_image" {
  description = "Worker container image URI"
  type        = string
}

variable "api_blue_target_group_arn" {
  description = "Blue target group ARN for API service"
  type        = string
}

variable "dashboard_blue_target_group_arn" {
  description = "Blue target group ARN for Dashboard service"
  type        = string
}

variable "api_desired_count" {
  description = "Desired task count for API service"
  type        = number
  default     = 2
}

variable "dashboard_desired_count" {
  description = "Desired task count for Dashboard service"
  type        = number
  default     = 2
}

variable "worker_desired_count" {
  description = "Desired task count for Worker service"
  type        = number
  default     = 1
}

variable "sqs_queue_url" {
  description = "SQS queue URL"
  type        = string
}

variable "sqs_queue_name" {
  description = "SQS queue name"
  type        = string
}

variable "db_secret_arn" {
  description = "Secrets Manager ARN containing database credentials"
  type        = string
}

variable "db_host" {
  description = "RDS PostgreSQL endpoint"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "redis_endpoint" {
  description = "ElastiCache Redis endpoint"
  type        = string
}

variable "db_username" {
  description = "RDS database username"
  type        = string
}

variable "db_password" {
  description = "RDS database password"
  type        = string
  sensitive   = true
}