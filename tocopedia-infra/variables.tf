variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "ssh_public_key" {
  description = "SSH public key content (e.g. contents of ~/.ssh/id_ed25519.pub)"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name for image uploads"
  type        = string
  default     = "tocopedia-images"
}
