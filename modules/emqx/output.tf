output "dashboard_target_group_arn" {
  value = aws_alb_target_group.emqx-server-dashboard.arn
}
