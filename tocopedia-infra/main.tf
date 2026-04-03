terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_ami" "ubuntu_arm64" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }
}

resource "aws_key_pair" "tocopedia" {
  key_name   = "tocopedia-key"
  public_key = var.ssh_public_key
}

resource "aws_security_group" "tocopedia" {
  name        = "tocopedia-backend"
  description = "Tocopedia backend: SSH + app port"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "API"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Project = "tocopedia" }
}

resource "aws_instance" "backend" {
  ami                    = data.aws_ami.ubuntu_arm64.id
  instance_type          = "t4g.nano"
  key_name               = aws_key_pair.tocopedia.key_name
  vpc_security_group_ids = [aws_security_group.tocopedia.id]

  user_data = <<-EOF
#!/bin/bash
set -e
apt-get update -y
apt-get install -y ca-certificates curl git
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
echo "deb [arch=arm64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu noble stable" > /etc/apt/sources.list.d/docker.list
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
systemctl enable --now docker
usermod -aG docker ubuntu
chmod 666 /var/run/docker.sock
EOF

  tags = {
    Name    = "tocopedia-backend"
    Project = "tocopedia"
  }
}
