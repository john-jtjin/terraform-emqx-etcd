## common
variable "region" {
  description = "AWS region"
  type        = string
}

variable "access_key" {
  description = "AWS access key"
  type        = string
  default     = ""
}

variable "secret_key" {
  description = "AWS secret key"
  type        = string
  default     = ""
}

variable "emqx_namespace" {
  description = "emqx namespace"
  type        = string
}


## vpc
variable "base_cidr_block" {
  description = "base cidr block"
  type        = string
}

variable "emqx_zone" {
  type        = map(number)
  description = "Map of AZ to a number that should be used for emqx subnets"
  # Note: `value` will be `netnum` argument in cidrsubnet function
  # Refer to https://www.terraform.io/language/functions/cidrsubnet
}

## security group
variable "emqx_ingress_with_cidr_blocks" {
  description = "ingress of emqx with cidr blocks"
  type        = list(any)
}

variable "egress_with_cidr_blocks" {
  description = "egress with cidr blocks"
  type        = list(any)
}

## ec2
variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
}

variable "instance_type" {
  description = "Instance type of emqx"
  type        = string
}

## emqx
variable "emqx_password" {
  description = "emqx password"
  type        = string
}

variable "emqx_version" {
  description = "emqx version"
  type        = string
}

variable "emqx_auth_url" {
  description = "emqx auth url"
  type        = string
}

variable "emqx_exhook_url" {
  description = "emqx exhook url"
  type        = string
}