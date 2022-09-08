resource "aws_alb_target_group" "emqx-server-dashboard" {
  vpc_id   = var.vpc_id
  name     = "emqx-server-dashboard"
  port     = 18083
  protocol = "HTTP"

  health_check {
    path    = "/status"
    matcher = "200-499"
  }
}

