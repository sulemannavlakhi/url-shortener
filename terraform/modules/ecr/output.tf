output "repository_urls" {
  value = { for k, v in aws_ecr_repository.service : k => v.repository_url }
}

output "repository_arns" {
  value = [for repo in aws_ecr_repository.service : repo.arn]
}
