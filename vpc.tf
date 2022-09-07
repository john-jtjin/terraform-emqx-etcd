resource "aws_vpc" "main" {
  cidr_block           = "10.4.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name        = "dev-indochat.vpc"
    EnvType     = "dev"
    ServiceName = "indochat"
  }
}