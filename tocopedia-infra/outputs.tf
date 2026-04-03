output "instance_id" {
  value = aws_instance.backend.id
}

output "public_ip" {
  value       = aws_instance.backend.public_ip
  description = "Public IP of the backend instance"
}

output "ssh_command" {
  value       = "ssh -i ~/.ssh/YOUR_KEY ec2-user@${aws_instance.backend.public_ip}"
  description = "SSH command to connect to the instance"
}

output "api_url" {
  value       = "http://${aws_instance.backend.public_ip}:${var.app_port}"
  description = "Base URL of the backend API"
}
