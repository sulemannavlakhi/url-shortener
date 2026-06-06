# creating codedeploy on ecs
resource "aws_codedeploy_app" "ecs" {
  compute_platform = "ECS"
  name             = "${var.project_name}-${var.environment}-ecs"
}