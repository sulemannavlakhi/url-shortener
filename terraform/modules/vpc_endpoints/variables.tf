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

variable "vpc_id" {
  description = "VPC ID where VPC endpoints will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs used by interface VPC endpoints"
  type        = list(string)
}

variable "private_route_table_id" {
  description = "Private route table ID used by gateway VPC endpoints"
  type        = string
}

variable "endpoint_sg_id" {
  description = "Security group ID attached to interface VPC endpoints"
  type        = string
}