output "ec2_elastic_ip" {
  description = "Elastic IP address attached to the public EC2 instance."
  value       = aws_eip.public_ec2_eip.public_ip
}

