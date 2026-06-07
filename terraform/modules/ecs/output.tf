output "cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "cluster_arn" {
  value = aws_ecs_cluster.main.arn
}

output "api_service_name" {
  value = aws_ecs_service.api.name
}

output "dashboard_service_name" {
  value = aws_ecs_service.dashboard.name
}

output "worker_service_name" {
  value = aws_ecs_service.worker.name
}

output "api_task_definition_arn" {
  value = aws_ecs_task_definition.api.arn
}

output "dashboard_task_definition_arn" {
  value = aws_ecs_task_definition.dashboard.arn
}

output "worker_task_definition_arn" {
  value = aws_ecs_task_definition.worker.arn
}
