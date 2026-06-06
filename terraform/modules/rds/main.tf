# generate a random 32 char password for the db, terraform manages this in state
resource "random_password" "db" {
  length  = 32
  special = true
}

# create the secret in secrets manager
resource "aws_secretsmanager_secret" "db" {
  name                    = "${var.project_name}/${var.environment}/rds/postgres"
  recovery_window_in_days = 0
}

# store the actual credentials as json. ecs will inject these into the containers at runtime
resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id

  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db.result
    dbname   = var.db_name
    engine   = "postgres"
  })
}

# using private subnets so the db is never directly reachable from the internet
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}