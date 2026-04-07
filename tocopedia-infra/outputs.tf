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

output "s3_bucket_name" {
  value       = aws_s3_bucket.images.bucket
  description = "S3 bucket name for image uploads"
}

output "deploy_access_key_id" {
  value       = aws_iam_access_key.deploy.id
  description = "Access key ID for the deploy IAM user"
}

output "deploy_secret_access_key" {
  value       = aws_iam_access_key.deploy.secret
  sensitive   = true
  description = "Secret access key for the deploy IAM user"
}
