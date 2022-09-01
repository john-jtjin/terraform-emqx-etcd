## common
region         = "ap-southeast-1"
emqx_namespace = "tf-emqx-cluster"
elb_namespace  = "tf-elb"
etcd_namespace = "tf-etcd"
vpc_namespace  = "tf-vpc"

## vpc
base_cidr_block = "10.0.0.0/16"
emqx_zone       = { "ap-southeast-1a" = 1 }
etcd_zone       = { "ap-southeast-1a" = 2 }
elb_zone        = { "ap-southeast-1a" = 3 }

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
  },
  {
    description = "cluster ekka"
    from_port   = 4370
    to_port     = 4370
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
  },
  {
    description = "cluster rpc"
    from_port   = 5370
    to_port     = 5370
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
  }
]
etcd_ingress_with_cidr_blocks = [
  {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
  },
  {
    description = "client_api"
    from_port   = 2379
    to_port     = 2379
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
instance_count              = 2
associate_public_ip_address = true

## nlb
forwarding_config = {
  "1883" = {
    dest_port   = 1883,
    protocol    = "TCP"
    description = "mqtt"
  },
  "8083" = {
    dest_port   = 8083,
    protocol    = "TCP"
    description = "ws"
  },
  "80" = {
    dest_port   = 18083,
    protocol    = "TCP"
    description = "dashboard"
  }
}
forwarding_config_ssl = {
  "8883" = {
    dest_port   = 1883,
    protocol    = "TLS"
    description = "mqtts"
  },
  "8084" = {
    dest_port   = 8083,
    protocol    = "TLS"
    description = "wss"
  }
}

## emqx
emqx_password   = "new-password"
emqx_version    = "5.0.6"
emqx_auth_url   = "https://cdn-source-dev.indochat.net:8080/mqtt/authz/\\$${clientid}"
emqx_exhook_url = "https://cdn-source-dev.indochat.net:8080"

## etcd
etcd_version = "v3.4.20"