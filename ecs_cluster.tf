resource "aws_cloudwatch_log_group" "indochat-ecs-log-group" {
  name = "${local.env}-indochat-ecs-log"
}
resource "aws_ecs_capacity_provider" "indochat" {
  name = "${local.env}-indochat"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.indochat-ecs-autoscaling-group.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 1
    }
  }
}
resource "aws_ecs_cluster_capacity_providers" "indochat" {
  cluster_name = aws_ecs_cluster.indochat.name

  capacity_providers = [aws_ecs_capacity_provider.indochat.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.indochat.name
  }
}

resource "aws_ecs_cluster" "indochat" {
  name = "${local.env}-indochat-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.indochat-ecs-log-group.name
      }
    }
  }


}
