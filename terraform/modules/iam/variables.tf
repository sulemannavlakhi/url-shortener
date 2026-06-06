variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS region where resources are deployed"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository connected to the CI/CD pipeline"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch monitored by the CI/CD pipeline"
  type        = string
}

variable "sqs_queue_arn" {
  description = "ARN of the SQS queue used by the worker service"
  type        = string
}

variable "rds_secret_arn" {
  description = "ARN of the Secrets Manager secret containing database credentials"
  type        = string
}

variable "ecr_repository_arns" {
  description = "List of ECR repository ARNs used by ECS services"
  type        = list(string)
}