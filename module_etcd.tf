module "etcd" {
  source              = "./modules/etcd"
  vpc_id              = aws_vpc.main.id
  ecs_cluster_id      = aws_ecs_cluster.indochat.id
  cloudwatch_log_name = aws_cloudwatch_log_group.indochat-ecs-log-group.name
}
