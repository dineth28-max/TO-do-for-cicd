output "ec2_elastic_ip" {
  description = "Elastic IP address attached to the public EC2 instance."
  value       = aws_eip.public_ec2_eip.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS name of the EC2 instance."
  value       = aws_instance.Public_ec2-1.public_dns
}