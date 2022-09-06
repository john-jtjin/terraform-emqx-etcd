output "elb_dns_name" {
  description = "The DNS name of the ELB"
  value       = aws_lb.lb.dns_name
}

output "target_group_arns" {
  description = "The arn of the elb target groups"
  # value       = aws_lb_target_group.tg.arn
  value = values(aws_lb_target_group.tg)[*].arn
}