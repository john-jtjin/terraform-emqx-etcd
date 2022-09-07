module "imgproxy" {
  source               = "./modules/imgproxy"
  vpc_id               = aws_vpc.main.id
  ecs_cluster_id       = aws_ecs_cluster.indochat.id
  imgproxy_key         = "0c8d233b842c"
  imgproxy_salt        = "75c506b9989c"
  imgproxy_path_prefix = "/p"
  cloudwatch_log_name  = aws_cloudwatch_log_group.indochat-ecs-log-group.name
}
