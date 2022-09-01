variable "namespace" {
  type = string
}

variable "sg_ids" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "associate_public_ip_address" {
  type = bool
}

variable "instance_type" {
  type = string
}

variable "instance_count" {
  type = number
}

variable "emqx_password" {
  type = string
}

variable "emqx_version" {
  type = string
}

variable "emqx_auth_url" {
  type = string
}

variable "emqx_exhook_url" {
  type = string
}

variable "emqx_etcd_url" {
  type = string
}