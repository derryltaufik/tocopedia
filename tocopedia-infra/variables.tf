variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "ssh_public_key" {
  description = "SSH public key content (e.g. contents of ~/.ssh/id_ed25519.pub)"
  type        = string
}
