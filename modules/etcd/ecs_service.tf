resource "aws_ecs_service" "etcd" {
  name            = "etcd"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.etcd.arn
  desired_count   = 1
  load_balancer {
    target_group_arn = aws_alb_target_group.etcd.arn
    container_name   = "etcd"
    container_port   = "2379"
  }

  capacity_provider_strategy {
    base              = 1
    capacity_provider = "dev-indochat"
    weight            = 100
  }
  deployment_controller {
    type = "ECS"
  }

}

