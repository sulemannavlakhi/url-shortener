variable "project_name" {
  description = "Project name used for naming resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "services" {
  description = "List of ECS services to create ECR repositories for"
  type        = list(string)
}