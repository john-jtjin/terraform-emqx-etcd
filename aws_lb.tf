resource "aws_lb" "etcd-nlb" {
  name               = "etcd-nlb"
  internal           = false
  load_balancer_type = "network"

  subnets = [aws_subnet.public-1a.id, aws_subnet.public-1b.id]
}

resource "aws_lb_listener" "etcd-discovery" {
  default_action {
    target_group_arn = module.etcd.nlb_target_group_arn
    type             = "forward"
  }

  load_balancer_arn = aws_lb.etcd-nlb.arn
  port              = 2379
  protocol          = "TCP"
}

resource "aws_lb" "indohcat-nlb" {
  name               = "dev-indochat-nlb"
  internal           = false
  load_balancer_type = "network"

  subnets = [aws_subnet.public-1a.id, aws_subnet.public-1b.id]
}

resource "aws_lb_listener" "indochat-nlb-emqx-mqtt" {
  default_action {
    target_group_arn = module.emqx.mqtt_target_group_arn
    type             = "forward"
  }

  load_balancer_arn = aws_lb.indohcat-nlb.arn
  port              = 1883
  protocol          = "TCP"
}



resource "aws_lb" "indohcat" {
  name               = "dev-indohcat"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.indochat-alb.id]
  subnets         = [aws_subnet.public-1a.id, aws_subnet.public-1b.id]
}


resource "aws_alb_listener" "indochat_http" {
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "indochat service"
      status_code  = "200"
    }
  }

  load_balancer_arn = aws_lb.indohcat.arn
  port              = 80
  protocol          = "HTTP"
}

resource "aws_lb_listener_rule" "emqx_dashboard" {
  listener_arn = aws_alb_listener.indochat_http.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = module.emqx.dashboard_target_group_arn
  }

  condition {
    host_header {
      values = ["emqx-dashboard-development.indochat.net"]
    }
  }
}

resource "aws_lb_listener_rule" "emqx_websocket" {
  listener_arn = aws_alb_listener.indochat_http.arn
  priority     = 98

  action {
    type             = "forward"
    target_group_arn = module.emqx.websocket_target_group_arn
  }

  condition {
    host_header {
      values = ["emqx-websocket-development.indochat.net"]
    }
  }
}

resource "aws_alb_listener" "emqx_dashboard" {
  default_action {
    target_group_arn = module.emqx.dashboard_target_group_arn
    type             = "forward"
  }

  load_balancer_arn = aws_lb.indohcat.arn
  port              = 18083
  protocol          = "HTTP"
}

resource "aws_alb_listener" "emqx_websocket" {
  default_action {
    target_group_arn = module.emqx.websocket_target_group_arn
    type             = "forward"
  }

  load_balancer_arn = aws_lb.indohcat.arn
  port              = 8083
  protocol          = "HTTP"
}



######################################
## create slef-signed ssl certificate
######################################
# resource "random_string" "app_keystore_password" {
#   length  = 16
#   special = false
# }

# resource "tls_private_key" "key" {
#   algorithm = "RSA"
# }

# resource "tls_self_signed_cert" "public_cert" {
#   # key_algorithm         = "RSA"
#   private_key_pem       = tls_private_key.key.private_key_pem
#   validity_period_hours = 87600

#   allowed_uses = [
#     "key_encipherment",
#     "digital_signature",
#     "server_auth",
#   ]

#   dns_names = ["*.ap-southeast-1.elb.amazonaws.com"]

#   subject {
#     common_name  = "*.ap-southeast-1.elb.amazonaws.com"
#     organization = "ORAG"
#     province     = "STATE"
#     country      = "COUNT"
#   }
# }

# resource "aws_acm_certificate" "cert" {
#   private_key      = tls_private_key.key.private_key_pem
#   certificate_body = tls_self_signed_cert.public_cert.cert_pem
# }


# resource "aws_lb_listener" "listener_ssl" {
#   load_balancer_arn = aws_lb.lb.arn
#   for_each          = var.forwarding_config_ssl
#   port              = each.key
#   protocol          = each.value.protocol
#   # certificate_arn   = var.certificate_arn
#   certificate_arn = aws_acm_certificate.cert.arn
#   default_action {
#     target_group_arn = aws_lb_target_group.tg_ssl[each.key].arn
#     type             = "forward"
#   }
# }

# resource "aws_lb_target_group" "tg_ssl" {
#   for_each = var.forwarding_config_ssl
#   name     = "${var.namespace}-tg-${each.value.dest_port}"
#   port     = each.value.dest_port
#   # protocol              = each.value.protocol
#   protocol    = "TCP"
#   vpc_id      = var.vpc_id
#   target_type = "instance"
#   # deregistration_delay    = 90
#   health_check {
#     interval            = 30
#     port                = each.value.dest_port
#     protocol            = "TCP"
#     healthy_threshold   = 3
#     unhealthy_threshold = 3
#   }
# }

# resource "aws_lb_target_group_attachment" "tga_ssl" {
#   for_each = {
#     for pair in setproduct(local.target_port_ssl, range(var.instance_count)) : "${pair[0]}:${pair[1]}" => {
#       dest_port = pair[0]
#       idx       = pair[1]
#     }
#   }

#   target_group_arn = aws_lb_target_group.tg_ssl[local.dest_to_src_ssl[each.value.dest_port]].arn
#   port             = each.value.dest_port
#   target_id        = var.instance_ids[each.value.idx]
# }