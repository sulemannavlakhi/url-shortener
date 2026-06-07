output "s3_endpoint_id" {
  value = aws_vpc_endpoint.s3.id
}

output "ecr_endpoint_id" {
  value = aws_vpc_endpoint.ecr.id
}

output "docker_endpoint_id" {
  value = aws_vpc_endpoint.docker.id
}

output "logs_endpoint_id" {
  value = aws_vpc_endpoint.logs.id
}

output "secretsmanager_endpoint_id" {
  value = aws_vpc_endpoint.secretsmanager.id
}

output "sqs_endpoint_id" {
  value = aws_vpc_endpoint.sqs.id
}