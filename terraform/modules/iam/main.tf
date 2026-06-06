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