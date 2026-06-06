# used by other modules to scope resources to this account
data "aws_caller_identity" "current" {}

# trust policy for all task roles, allows ecs to assume them
data "aws_iam_policy_document" "ecs_tasks_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# execution role for pulling images, writing logs
resource "aws_iam_role" "execution" {
  name               = "${var.project_name}-${var.environment}-ecs-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume.json
}

# policy that covers ecr pull, cloudwatch logs
resource "aws_iam_role_policy_attachment" "execution_managed" {
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ecs injects secrets as env vars at container start via secrets manager
resource "aws_iam_role_policy" "execution_secrets" {
  name = "${var.project_name}-${var.environment}-execution-secrets"
  role = aws_iam_role.execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = [var.rds_secret_arn]
      }
    ]
  })
}

# api task role - the container process assumes this at runtime
resource "aws_iam_role" "api_task" {
  name               = "${var.project_name}-${var.environment}-api-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume.json
}

# api needs to publish click events to sqs and read db creds
resource "aws_iam_role_policy" "api_task" {
  name = "${var.project_name}-${var.environment}-api-policy"
  role = aws_iam_role.api_task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["sqs:SendMessage", "sqs:GetQueueAttributes", "sqs:GetQueueUrl"]
        Resource = var.sqs_queue_arn
      },
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = var.rds_secret_arn
      }
    ]
  })
}

# worker task role
resource "aws_iam_role" "worker_task" {
  name               = "${var.project_name}-${var.environment}-worker-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume.json
}

# worker polls sqs and writes analytics to rds needs consume permissions
# changeMessageVisibility lets it extend the timeout if processing takes longer
resource "aws_iam_role_policy" "worker_task" {
  name = "${var.project_name}-${var.environment}-worker-policy"
  role = aws_iam_role.worker_task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:ChangeMessageVisibility",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl"
        ]
        Resource = var.sqs_queue_arn
      },
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = var.rds_secret_arn
      }
    ]
  })
}

# dashboard task role
resource "aws_iam_role" "dashboard_task" {
  name               = "${var.project_name}-${var.environment}-dashboard-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume.json
}

# dashboard is read-only against rds, no queue access needed
resource "aws_iam_role_policy" "dashboard_task" {
  name = "${var.project_name}-${var.environment}-dashboard-policy"
  role = aws_iam_role.dashboard_task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = var.rds_secret_arn
      }
    ]
  })
}

# codedeploy needs its own role to orchestrate blue/green swaps on ecs
resource "aws_iam_role" "codedeploy" {
  name = "${var.project_name}-${var.environment}-codedeploy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "codedeploy.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

# policy for everything codedeploy needs for ecs deployments
resource "aws_iam_role_policy_attachment" "codedeploy_ecs" {
  role       = aws_iam_role.codedeploy.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}