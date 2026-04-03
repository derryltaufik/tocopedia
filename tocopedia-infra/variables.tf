variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "ssh_public_key" {
  description = "SSH public key content (e.g. contents of ~/.ssh/id_ed25519.pub)"
  type        = string
}

variable "ssh_allowed_cidrs" {
  description = "CIDR blocks allowed to SSH. Restrict to your IP for security."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "app_port" {
  description = "Port the backend API listens on"
  type        = number
  default     = 3000
}
