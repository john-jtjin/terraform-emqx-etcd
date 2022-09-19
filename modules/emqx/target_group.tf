resource "aws_alb_target_group" "emqx-server-dashboard" {
  vpc_id   = var.vpc_id
  name     = "emqx-server-dashboard"
  port     = 18083
  protocol = "HTTP"

  health_check {
    path    = "/status"
    matcher = "200"
  }
}

resource "aws_lb_target_group" "emqx-server-mqtt" {
  vpc_id   = var.vpc_id
  name     = "emqx-server-mqtt"
  port     = 1883
  protocol = "TCP"

  health_check {
    port     = "traffic-port"
    protocol = "TCP"
  }
}

resource "aws_alb_target_group" "emqx-server-websocket" {
  vpc_id   = var.vpc_id
  name     = "emqx-server-websocket"
  port     = 8083
  protocol = "HTTP"

  health_check {
    path    = "/"
    matcher = "200-499"
  }
}