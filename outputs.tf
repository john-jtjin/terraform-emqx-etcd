output "emqx_address" {
  description = "public ip of emqx-ec2"
  value       = module.emqx_ec2.public_ip
}