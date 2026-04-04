output "instance_id" {
  value = aws_instance.backend.id
}

output "public_ip" {
  value       = aws_instance.backend.public_ip
  description = "Public IP of the backend instance"
}

output "ssh_command" {
  value       = "ssh ubuntu@${aws_instance.backend.public_ip}"
  description = "SSH command to connect to the instance"
}

