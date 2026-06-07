output "alb_arn" {
  value = aws_lb.alb.arn
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.alb.zone_id
}

output "http_listener_arn" {
  value = aws_lb_listener.http.arn
}

output "https_listener_arn" {
  value = aws_lb_listener.https.arn
}

output "api_blue_target_group_arn" {
  value = aws_lb_target_group.api_blue.arn
}

output "api_green_target_group_arn" {
  value = aws_lb_target_group.api_green.arn
}

output "dashboard_blue_target_group_arn" {
  value = aws_lb_target_group.dashboard_blue.arn
}

output "dashboard_green_target_group_arn" {
  value = aws_lb_target_group.dashboard_green.arn
}

output "api_blue_target_group_name" {
  value = aws_lb_target_group.api_blue.name
}

output "api_green_target_group_name" {
  value = aws_lb_target_group.api_green.name
}

output "dashboard_blue_target_group_name" {
  value = aws_lb_target_group.dashboard_blue.name
}

output "dashboard_green_target_group_name" {
  value = aws_lb_target_group.dashboard_green.name
}