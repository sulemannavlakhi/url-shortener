output "ecs_task_execution_role_arn" {
  value = aws_iam_role.execution.arn
}

output "api_task_role_arn" {
  value = aws_iam_role.api_task.arn
}

output "worker_task_role_arn" {
  value = aws_iam_role.worker_task.arn
}

output "dashboard_task_role_arn" {
  value = aws_iam_role.dashboard_task.arn
}

output "codedeploy_role_arn" {
  value = aws_iam_role.codedeploy.arn
}

output "github_actions_role_arn" {
  value = aws_iam_role.github_actions.arn
}
