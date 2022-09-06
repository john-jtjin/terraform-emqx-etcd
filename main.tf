#######################################
## vpc modules
#######################################

module "vpc" {
  source = "./modules/vpc"

  vpc_namespace   = var.vpc_namespace
  base_cidr_block = var.base_cidr_block
}

#######################################
## subnets modules
#######################################

module "emqx_subnet" {
  source = "./modules/subnet"

  namespace  = var.emqx_namespace
  vpc_id     = module.vpc.vpc_id
  cidr_block = var.base_cidr_block
  gateway_id = module.vpc.gw_id
  zone       = var.emqx_zone
}

module "elb_subnet" {
  source = "./modules/subnet"

  namespace  = var.elb_namespace
  vpc_id     = module.vpc.vpc_id
  cidr_block = var.base_cidr_block
  gateway_id = module.vpc.gw_id
  zone       = var.elb_zone
}

module "etcd_subnet" {
  source = "./modules/subnet"

  namespace  = var.etcd_namespace
  vpc_id     = module.vpc.vpc_id
  cidr_block = var.base_cidr_block
  gateway_id = module.vpc.gw_id
  zone       = var.etcd_zone
}

#######################################
## security group modules
#######################################
module "emqx_security_group" {
  source = "./modules/security_group"

  namespace                = var.emqx_namespace
  vpc_id                   = module.vpc.vpc_id
  ingress_with_cidr_blocks = var.emqx_ingress_with_cidr_blocks
  egress_with_cidr_blocks  = var.egress_with_cidr_blocks
}

module "etcd_security_group" {
  source = "./modules/security_group"

  namespace                = var.etcd_namespace
  vpc_id                   = module.vpc.vpc_id
  ingress_with_cidr_blocks = var.etcd_ingress_with_cidr_blocks
  egress_with_cidr_blocks  = var.egress_with_cidr_blocks
}

#######################################
## ec2 modules
#######################################
module "emqx_cluster_ec2" {
  source = "./modules/emqx_cluster"

  namespace                   = var.emqx_namespace
  instance_count              = var.instance_count
  instance_type               = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  subnet_ids                  = module.emqx_subnet.subnet_ids
  sg_ids                      = [module.emqx_security_group.sg_id]
  emqx_password               = var.emqx_password
  emqx_version                = var.emqx_version
  emqx_auth_url               = var.emqx_auth_url
  emqx_exhook_url             = var.emqx_exhook_url
  emqx_etcd_url               = "http://${module.etcd_ec2.private_ip}:2379"
  lb_target_group_arns        = module.elb.target_group_arns

  depends_on = [module.etcd_ec2, module.elb]
}

module "etcd_ec2" {
  source = "./modules/etcd"

  namespace                   = var.etcd_namespace
  instance_type               = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  subnet_ids                  = module.etcd_subnet.subnet_ids
  sg_ids                      = [module.etcd_security_group.sg_id]
  etcd_version                = var.etcd_version
}

#######################################
## elb modules
#######################################

module "elb" {
  source = "./modules/elb"

  namespace             = var.elb_namespace
  region                = var.region
  instance_count        = var.instance_count
  subnet_ids            = module.elb_subnet.subnet_ids
  forwarding_config     = var.forwarding_config
  forwarding_config_ssl = var.forwarding_config_ssl
  vpc_id                = module.vpc.vpc_id

}