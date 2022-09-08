resource "aws_lb" "etcd" {
  name               = "dev-etcd"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.indochat-alb.id]
  subnets         = [aws_subnet.public-1a.id, aws_subnet.public-1b.id]

}

resource "aws_alb_listener" "etcd_http" {
  default_action {
    target_group_arn = module.etcd.alb_target_group_arn
    type             = "forward"
  }

  load_balancer_arn = aws_lb.etcd.arn
  port              = 2379
  protocol          = "HTTP"
}