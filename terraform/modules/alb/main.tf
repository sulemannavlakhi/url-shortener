# creating ALB in public subnets
resource "aws_lb" "alb" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "${var.project_name}-${var.environment}-alb"
  }
}

# blue target group for the api
resource "aws_lb_target_group" "api_blue" {
  name        = "${var.project_name}-${var.environment}-api-blue"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/healthz"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

# green target group for the api
resource "aws_lb_target_group" "api_green" {
  name        = "${var.project_name}-${var.environment}-api-green"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/healthz"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

# blue target group for the dashboard
resource "aws_lb_target_group" "dashboard_blue" {
  name        = "${var.project_name}-${var.environment}-dash-blue"
  port        = 8081
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/healthz"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

# green target group for the dashboard
resource "aws_lb_target_group" "dashboard_green" {
  name        = "${var.project_name}-${var.environment}-dash-green"
  port        = 8081
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/healthz"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

# http listener redirects all traffic to https
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# https listener, forwards to api blue by default
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_blue.arn
  }

  lifecycle {
    ignore_changes = [default_action]
  }
}

locals {
  listener_arn = aws_lb_listener.https.arn
}

# ignore_changes so codedeploy can update the target group without terraform reverting it
resource "aws_lb_listener_rule" "api_host" {
  listener_arn = local.listener_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_blue.arn
  }

  condition {
    host_header {
      values = ["api.sulemannav.com"]
    }
  }

  lifecycle {
    ignore_changes = [action]
  }
}

# routes domain to the dashboard service
resource "aws_lb_listener_rule" "dashboard_host" {
  listener_arn = local.listener_arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashboard_blue.arn
  }

  condition {
    host_header {
      values = ["dashboard.sulemannav.com"]
    }
  }

  lifecycle {
    ignore_changes = [action]
  }
}