variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs used for the ElastiCache subnet group"
  type        = list(string)
}

variable "redis_sg_id" {
  description = "Security group ID attached to the Redis cluster"
  type        = string
}

variable "node_type" {
  description = "ElastiCache Redis node type (e.g. cache.t3.micro, cache.t3.small)"
  type        = string
}