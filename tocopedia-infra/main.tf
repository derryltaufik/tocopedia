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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Project = "tocopedia" }
}

resource "aws_s3_bucket" "images" {
  bucket = var.s3_bucket_name

  tags = { Project = "tocopedia" }
}

resource "aws_s3_bucket_public_access_block" "images" {
  bucket = aws_s3_bucket.images.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "images_public_read" {
  bucket = aws_s3_bucket.images.id
  depends_on = [aws_s3_bucket_public_access_block.images]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.images.arn}/*"
    }]
  })
}

resource "aws_iam_user" "s3_uploader" {
  name = "tocopedia-s3-uploader"
  tags = { Project = "tocopedia" }
}

resource "aws_iam_user_policy" "s3_upload" {
  name = "s3-upload"
  user = aws_iam_user.s3_uploader.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "s3:PutObject"
      Resource = "${aws_s3_bucket.images.arn}/*"
    }]
  })
}

resource "aws_iam_user_policy" "eice_access" {
  name = "eice-access"
  user = aws_iam_user.s3_uploader.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2-instance-connect:OpenTunnel",
          "ec2-instance-connect:SendSSHPublicKey"
        ]
        Resource = [
          aws_instance.backend.arn,
          aws_ec2_instance_connect_endpoint.backend.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceConnectEndpoints"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_access_key" "s3_uploader" {
  user = aws_iam_user.s3_uploader.name
}

# Look up default VPC and its first subnet for EICE
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_ec2_instance_connect_endpoint" "backend" {
  subnet_id          = data.aws_subnets.default.ids[0]
  security_group_ids = [aws_security_group.tocopedia.id]
  preserve_client_ip = false

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
su - ubuntu -c "git clone https://github.com/derryltaufik/tocopedia.git /home/ubuntu/tocopedia"
EOF

  tags = {
    Name    = "tocopedia-backend"
    Project = "tocopedia"
  }
}
