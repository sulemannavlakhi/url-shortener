variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where resources will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security group ID attached to the Application Load Balancer"
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate used for HTTPS"
  type        = string
}

variable "api_hostname" {
  description = "Hostname for the API service"
  type        = string
}

variable "dashboard_hostname" {
  description = "Hostname for the dashboard service"
  type        = string
}