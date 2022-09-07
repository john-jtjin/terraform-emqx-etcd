resource "aws_launch_configuration" "indochat-ecs-launch-config" {
  name_prefix = "indochat-ecs-launch-cfg"

  # form https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
  image_id             = "ami-08222ba0572c64812"
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name

  instance_type = "t2.micro"
  user_data     = base64encode("#!/bin/bash\necho ECS_CLUSTER=dev-indochat-cluster >> /etc/ecs/ecs.config\ncd /tmp\nsudo yum -y update\nsudo yum install -y amazon-cloudwatch-agent \nsudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm\nsudo systemctl enable amazon-ssm-agent\nsudo systemctl start amazon-ssm-agent")

  key_name        = "tf"
  security_groups = [aws_security_group.indochat-ecs-ec2.id]
  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "indochat-ecs-autoscaling-group" {
  name                = "${local.env}-indochat-ecs-autoscaling-group"
  vpc_zone_identifier = [aws_subnet.public-1a.id, aws_subnet.public-1b.id]
  # vpc_zone_identifier       = [aws_subnet.private-1a.id, aws_subnet.private-1b.id]
  launch_configuration      = aws_launch_configuration.indochat-ecs-launch-config.name
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
}
