resource "aws_alb_target_group" "imgproxy" {
  vpc_id   = var.vpc_id
  name     = "imgproxy"
  port     = 8080
  protocol = "HTTP"
}

