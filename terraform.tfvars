## common
region         = "ap-southeast-1"
emqx_namespace = "tf-emqx-single"

## vpc
base_cidr_block = "10.0.0.0/16"
emqx_zone       = { "ap-southeast-1a" = 1 }

## security group
emqx_ingress_with_cidr_blocks = [
  {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
  },
  {
    description = "mqtt"
    from_port   = 1883
    to_port     = 1883
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
  },
  {
    description = "mqtts"
    from_port   = 8883
    to_port     = 8883
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
  },
  {
    description = "ws"
    from_port   = 8083
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
  },
  {
    description = "wss"
    from_port   = 8084
    to_port     = 8084
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
  },
  {
    description = "dashboard"
    from_port   = 18083
    to_port     = 18083
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
  }
]
egress_with_cidr_blocks = [
  {
    description = "all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "0.0.0.0/0"
  }
]

## ec2
instance_type               = "t2.micro"
associate_public_ip_address = true

## emqx
emqx_password   = "new-password"
emqx_version    = "5.0.7"
emqx_auth_url   = "https://cdn-source-dev.indochat.net:8080/mqtt/authz/\\$${clientid}"
emqx_exhook_url = "https://cdn-source-dev.indochat.net:8080"