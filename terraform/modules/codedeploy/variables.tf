variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
}

variable "codedeploy_role_arn" {
  description = "IAM role ARN granted to CodeDeploy for ECS deployments"
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster where services are deployed"
  type        = string
}

variable "api_service_name" {
  description = "Name of the ECS service running the API"
  type        = string
}

variable "dashboard_service_name" {
  description = "Name of the ECS service running the dashboard"
  type        = string
}

variable "alb_listener_arn" {
  description = "ARN of the ALB HTTPS listener used by CodeDeploy deployment groups"
  type        = string
}

variable "api_blue_target_group_name" {
  description = "Name of the blue target group for the API service blue/green deployment"
  type        = string
}

variable "api_green_target_group_name" {
  description = "Name of the green target group for the API service blue/green deployment"
  type        = string
}

variable "dashboard_blue_target_group_name" {
  description = "Name of the blue target group for the dashboard service blue/green deployment"
  type        = string
}

variable "dashboard_green_target_group_name" {
  description = "Name of the green target group for the dashboard service blue/green deployment"
  type        = string
}