output "ids" {
  value = aws_instance.ec2.*.id
}