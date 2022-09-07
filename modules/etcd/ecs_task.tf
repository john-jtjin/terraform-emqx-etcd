resource "aws_ecs_task_definition" "etcd" {
  family                   = "etcd"
  requires_compatibilities = ["EC2"]

  container_definitions = jsonencode([
    {
      name         = "etcd"
      image        = "bitnami/etcd:3.4.20"
      memory       = 256
      network_mode = "bridge" # dynamic port mapping
      portMappings = [
        {
          containerPort = 2379
          hostPort      = 0 # dynamic port mapping
        }
      ]
      environment = [
        { "name" : "ETCD_LISTEN_CLIENT_URLS", "value" : "http://0.0.0.0:2379" },
        { "name" : "ALLOW_NONE_AUTHENTICATION", "value" : "yes" },
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group" : var.cloudwatch_log_name
          "awslogs-region" : "ap-southeast-1",
          "awslogs-stream-prefix" : "etcd"
        }
      }
    }
  ])
  tags = {}
}
