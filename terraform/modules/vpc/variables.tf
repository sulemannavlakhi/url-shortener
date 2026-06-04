variable "project_name" {
  description = "Project name used for tagging resources"
  type        = string
  default     = "ecsv2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)

  default = [
    "10.0.101.0/24",
    "10.0.102.0/24"
  ]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)

  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "azs" {
  description = "Availability zones for subnets"
  type        = list(string)

  default = [
    "ca-central-1a",
    "ca-central-1b"
  ]
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ca-central-1"
}