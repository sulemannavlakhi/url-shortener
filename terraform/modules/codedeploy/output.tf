output "app_name" {
  value = aws_codedeploy_app.ecs.name
}

output "api_deployment_group_name" {
  value = aws_codedeploy_deployment_group.api.deployment_group_name
}

output "dashboard_deployment_group_name" {
  value = aws_codedeploy_deployment_group.dashboard.deployment_group_name
}
