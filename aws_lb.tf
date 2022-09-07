resource "aws_lb" "indohcat" {
  name               = "dev-indochat"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.indochat-alb.id]
  subnets         = [aws_subnet.public-1a.id, aws_subnet.public-1b.id]

}

resource "aws_alb_listener" "indochat_http" {
  default_action {
    target_group_arn = module.imgproxy.alb_target_group_arn
    type             = "forward"
  }

  load_balancer_arn = aws_lb.indohcat.arn
  port              = 80
  protocol          = "HTTP"
}
