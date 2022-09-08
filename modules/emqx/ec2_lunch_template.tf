resource "aws_launch_template" "emqx-server" {
  name          = "emqx-server-${var.env}"
  instance_type = var.instance_type

  // Ubuntu 20.04 LTS ami-04ff9e9b51c1f62ca
  image_id = "ami-04ff9e9b51c1f62ca"
  iam_instance_profile {
    #arn = aws_iam_instance_profile.etourist-server.arn
  }
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.emqx-server.id]
  }
  user_data = base64encode(templatefile("${path.module}/assets/init.sh", {
    EMQX_VERSION = var.emqx_version,
    NEW_PASSWORD = var.emqx_password,
    AUTH_URL     = var.emqx_auth_url
    EXHOOK_URL   = var.emqx_exhook_url,
    ETCD_URL     = var.emqx_etcd_url,
  }))
  update_default_version = true

  monitoring {
    enabled = true
  }
}

