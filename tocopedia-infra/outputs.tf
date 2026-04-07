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

output "s3_uploader_access_key_id" {
  value       = aws_iam_access_key.s3_uploader.id
  description = "Access key ID for the S3 uploader IAM user"
}

output "s3_uploader_secret_access_key" {
  value       = aws_iam_access_key.s3_uploader.secret
  sensitive   = true
  description = "Secret access key for the S3 uploader IAM user"
}
