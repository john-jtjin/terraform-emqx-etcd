resource "aws_lb_target_group" "etcd" {
  vpc_id   = var.vpc_id
  name     = "etcd"
  port     = 2379
  protocol = "TCP"

  health_check {
    port     = "traffic-port"
    protocol = "TCP"
  }
}

