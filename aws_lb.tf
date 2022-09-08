resource "aws_lb" "nlb" {
  name               = "nlb"
  internal           = false
  load_balancer_type = "network"

  subnets = [aws_subnet.public-1a.id, aws_subnet.public-1b.id]
}

resource "aws_lb_listener" "nlb-etcd" {
  default_action {
    target_group_arn = module.etcd.nlb_target_group_arn
    type             = "forward"
  }

  load_balancer_arn = aws_lb.nlb.arn
  port              = 2379
  protocol          = "TCP"
}

# resource "aws_alb_listener" "emqx_dashboard" {
#   default_action {
#     target_group_arn = module.emqx.dashboard_target_group_arn
#     type             = "forward"
#   }

#   load_balancer_arn = aws_lb.etcd.arn
#   port              = 18083
#   protocol          = "HTTP"
# }