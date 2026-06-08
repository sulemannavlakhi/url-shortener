variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ca-central-1"
}

variable "project_name" {
  description = "Project name used for naming and tags"
  type        = string
  default     = "ecsv2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs for ALB"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs for ECS, RDS, Redis"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["ca-central-1a", "ca-central-1b"]
}

variable "domain_name" {
  description = "Root domain name, for example example.com. Leave empty to skip Route 53 records in this scaffold."
  type        = string
  default     = ""
}

variable "api_hostname" {
  description = "API hostname, for example short.example.com"
  type        = string
  default     = ""
}

variable "dashboard_hostname" {
  description = "Dashboard hostname, for example dashboard.example.com"
  type        = string
  default     = ""
}

variable "certificate_arn" {
  description = "Existing ACM certificate ARN for HTTPS listener. Must be in the same region as the ALB."
  type        = string
  default     = ""
}

variable "github_repo" {
  description = "GitHub repo allowed to assume the deploy role, format owner/repo"
  type        = string
  default     = "sulemannavlakhi/ecsv2"
}

variable "github_branch" {
  description = "Branch allowed to deploy through OIDC"
  type        = string
  default     = "main"
}

variable "container_image_tag" {
  description = "Initial image tag used by Terraform. CI/CD should deploy immutable SHA tags after initial setup."
  type        = string
  default     = "latest"
}

variable "api_desired_count" {
  type    = number
  default = 2
}

variable "dashboard_desired_count" {
  type    = number
  default = 2
}

variable "worker_desired_count" {
  type    = number
  default = 1
}

variable "db_name" {
  type    = string
  default = "analytics"
}

variable "db_username" {
  type    = string
  default = "ecsv2_admin"
}

variable "db_instance_class" {
  type    = string
  default = "db.t4g.micro"
}

variable "redis_node_type" {
  type    = string
  default = "cache.t4g.micro"
}

variable "allowed_alb_ingress_cidrs" {
  description = "CIDR ranges allowed to reach the public ALB"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "db_password" {
  description = "RDS database password"
  type        = string
  sensitive   = true
}