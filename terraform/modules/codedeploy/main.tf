# creating codedeploy on ecs
resource "aws_codedeploy_app" "ecs" {
  compute_platform = "ECS"
  name             = "${var.project_name}-${var.environment}-ecs"
}

# deployment group for the api service
# old tasks are terminated 5 minutes after a successful deployment
resource "aws_codedeploy_deployment_group" "api" {
  app_name               = aws_codedeploy_app.ecs.name
  deployment_group_name  = "${var.project_name}-${var.environment}-api-dg"
  service_role_arn       = var.codedeploy_role_arn
  deployment_config_name = "CodeDeployDefault.ECSCanary10Percent5Minutes"

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  # auto continue after the canary period, no manual approval needed
  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    # keep old tasks around for 5 minutes after success in case we need to roll back manually
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  # roll back automatically on failure or if a cloudwatch alarm fires
  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE", "DEPLOYMENT_STOP_ON_ALARM"]
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.api_service_name
  }

  # codedeploy shifts traffic between blue and green target groups on the alb
  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.alb_listener_arn]
      }

      target_group {
        name = var.api_blue_target_group_name
      }

      target_group {
        name = var.api_green_target_group_name
      }
    }
  }
}