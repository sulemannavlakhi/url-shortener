# s3 endpoint so ecs tasks can reach s3 without needing a nat gateway
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [var.private_route_table_id]

  tags = {
    Name = "${var.project_name}-${var.environment}-s3-endpoint"
  }
}

# endpoint for ecr 
resource "aws_vpc_endpoint" "ecr" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [var.endpoint_sg_id]
  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-${var.environment}-ecr-endpoint"
  }
}

# endpoint for docker to pull the actual image from ecr
resource "aws_vpc_endpoint" "docker" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [var.endpoint_sg_id]
  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-${var.environment}-docker-endpoint"
  }
}

# vpc endpoint for cloudwatch logs
resource "aws_vpc_endpoint" "logs" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [var.endpoint_sg_id]
  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-${var.environment}-logs-endpoint"
  }
}

# vpc endpoint for secret manager 
resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [var.endpoint_sg_id]
  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-${var.environment}-secretsmanager-endpoint"
  }
}

# vpc endpoint for sqs 
resource "aws_vpc_endpoint" "sqs" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.sqs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [var.endpoint_sg_id]
  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-${var.environment}-sqs-endpoint"
  }
}