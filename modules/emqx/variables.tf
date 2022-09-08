variable "env" {
  description = "env (prod|stag|dev)"
}

variable "vpc_id" {
  description = "vpc_id"
}

variable "subnet_ids" {
  description = "subnet_ids"
}

variable "instance_type" {
  description = "emqx instance_type"
}

variable "emqx_password" {
  description = "emqx dashboard password"
}

variable "emqx_version" {
  description = "emqx version"
}

variable "emqx_auth_url" {
  description = "emqx auth url"
}

variable "emqx_exhook_url" {
  description = "emqx exhook url"
}

variable "emqx_etcd_url" {
  description = "emqx etcd url"
}
