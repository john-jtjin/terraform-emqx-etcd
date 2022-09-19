output "dashboard_target_group_arn" {
  value = aws_alb_target_group.emqx-server-dashboard.arn
}

output "mqtt_target_group_arn" {
  value = aws_lb_target_group.emqx-server-mqtt.arn
}

output "websocket_target_group_arn" {
  value = aws_alb_target_group.emqx-server-websocket.arn
}