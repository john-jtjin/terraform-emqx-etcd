locals {
  timestamp       = formatdate("DD-MMM-YYYY-hh:mm", timestamp())
  emqx_anchor     = element(aws_instance.ec2[*].private_ip, 0)
  emqx_rest       = slice(aws_instance.ec2[*].public_ip, 1, var.instance_count)
  emqx_rest_count = var.instance_count - 1
}

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

// ssh certificate
resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "local_file" "private_key" {
  filename          = "${path.module}/tf-emqx-key.pem"
  sensitive_content = tls_private_key.key.private_key_pem
  file_permission   = "0400"
}

resource "aws_key_pair" "key_pair" {
  key_name   = "tf-emqx-cluster-key"
  public_key = tls_private_key.key.public_key_openssh
}

// Configure the EC2 instance in a public subnet
resource "aws_instance" "ec2" {
  count = var.instance_count

  ami = data.aws_ami.ubuntu.id
  // always be true as you have to get public ip
  associate_public_ip_address = var.associate_public_ip_address
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids      = var.sg_ids
  key_name                    = aws_key_pair.key_pair.key_name

  tags = {
    Name = "${var.namespace}-ec2-${count.index + 1}"
  }
}

resource "null_resource" "ssh_connection" {
  depends_on = [aws_instance.ec2]

  count = var.instance_count
  connection {
    type        = "ssh"
    host        = aws_instance.ec2[count.index].public_ip
    user        = "ubuntu"
    private_key = tls_private_key.key.private_key_pem
  }

  # create init script
  provisioner "file" {
    content = templatefile("${path.module}/scripts/init.sh", {
      EMQX_VERSION = var.emqx_version,
      NEW_PASSWORD = var.emqx_password,
      AUTH_URL     = var.emqx_auth_url
      EXHOOK_URL   = var.emqx_exhook_url,
      LOCAL_IP     = aws_instance.ec2[count.index].private_ip,
      ETCD_URL     = var.emqx_etcd_url,
    })
    destination = "/tmp/init.sh"
  }

  # init system
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/init.sh",
      "/tmp/init.sh",
    ]
  }
}