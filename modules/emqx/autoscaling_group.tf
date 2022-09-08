resource "aws_autoscaling_group" "indochat-emqx-autoscaling-group" {
  name                      = "${var.env}-indochat-emqx-autoscaling-group"
  vpc_zone_identifier       = var.subnet_ids
  target_group_arns         = [aws_alb_target_group.emqx-server-dashboard.arn]
  health_check_grace_period = 300
  health_check_type         = "ELB"
  launch_template {
    id      = aws_launch_template.emqx-server.id
    version = aws_launch_template.emqx-server.latest_version
  }
  min_size                  = 0
  max_size                  = 4
  desired_capacity          = 2
  wait_for_capacity_timeout = 0
}