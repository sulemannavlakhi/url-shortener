variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs used for the RDS subnet group"
  type        = list(string)
}

variable "rds_sg_id" {
  description = "Security group ID attached to the RDS instance"
  type        = string
}

variable "db_name" {
  description = "Name of the application database"
  type        = string
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class (e.g. db.t3.micro, db.t3.small)"
  type        = string
}