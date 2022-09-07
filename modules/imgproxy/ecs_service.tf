resource "aws_ecs_service" "imgproxy" {
  name            = "imgproxy"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.imgproxy.arn
  desired_count   = 1
  load_balancer {
    target_group_arn = aws_alb_target_group.imgproxy.arn
    container_name   = "imgproxy"
    container_port   = "8080"
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

