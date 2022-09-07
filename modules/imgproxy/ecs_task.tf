resource "aws_ecs_task_definition" "imgproxy" {
  family                   = "imgproxy"
  requires_compatibilities = ["EC2"]

  container_definitions = jsonencode([
    {
      name         = "imgproxy"
      image        = "darthsim/imgproxy:latest"
      memory       = 256
      network_mode = "bridge" # dynamic port mapping
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 0 # dynamic port mapping
        }
      ]
      environment = [
        { "name" : "IMGPROXY_KEY", "value" : var.imgproxy_key },
        { "name" : "IMGPROXY_SALT", "value" : var.imgproxy_salt },
        { "name" : "IMGPROXY_PATH_PREFIX", "value" : var.imgproxy_path_prefix },
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group" : var.cloudwatch_log_name
          "awslogs-region" : "ap-southeast-1",
          "awslogs-stream-prefix" : "imgproxy"
        }
      }
    }
  ])
  tags = {}
}
