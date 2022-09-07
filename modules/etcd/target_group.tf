resource "aws_alb_target_group" "etcd" {
  vpc_id   = var.vpc_id
  name     = "etcd"
  port     = 2379
  protocol = "HTTP"

  health_check {
    path    = "/version"
    matcher = "200"
  }
}

