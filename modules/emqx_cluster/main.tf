// ami
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_template" "ec2" {
  image_id = data.aws_ami.ubuntu.id

  name                                 = "emqx-ec2"
  instance_type                        = var.instance_type
  instance_initiated_shutdown_behavior = "terminate"

  network_interfaces {
    // always be true as you have to get public ip
    associate_public_ip_address = var.associate_public_ip_address
    security_groups             = var.sg_ids
    subnet_id                   = var.subnet_ids[0]
  }

  user_data = base64encode(templatefile("${path.module}/scripts/init.sh", {
    EMQX_VERSION = var.emqx_version,
    NEW_PASSWORD = var.emqx_password,
    AUTH_URL     = var.emqx_auth_url
    EXHOOK_URL   = var.emqx_exhook_url,
    ETCD_URL     = var.emqx_etcd_url,
  }))
}

resource "aws_autoscaling_group" "emqx-ec2" {
  name                      = "emqx-ec2-${aws_launch_template.ec2.latest_version}"
  target_group_arns         = var.lb_target_group_arns
  health_check_grace_period = 300
  health_check_type         = "ELB"
  launch_template {
    id      = aws_launch_template.ec2.id
    version = aws_launch_template.ec2.latest_version
  }
  min_size = 2
  max_size = 4
}