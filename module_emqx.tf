# module "emqx" {
#   source          = "./modules/emqx"
#   env             = local.env
#   vpc_id          = aws_vpc.main.id
#   subnet_ids      = [aws_subnet.public-1a.id, aws_subnet.public-1b.id]
#   instance_type   = "t2.micro"
#   emqx_password   = "new-password"
#   emqx_version    = "5.0.6"
#   emqx_auth_url   = "https://cdn-source-dev.indochat.net:8080/mqtt/authz/\\$${clientid}"
#   emqx_exhook_url = "https://cdn-source-dev.indochat.net:8080"
#   emqx_etcd_url   = "http://${aws_lb.etcd.dns_name}:2379"

#   depends_on = [module.etcd]
# }
