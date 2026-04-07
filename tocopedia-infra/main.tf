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

resource "aws_iam_user_policy" "ecr_access" {
  name = "ecr-access"
  user = aws_iam_user.s3_uploader.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "ecr:GetAuthorizationToken"
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = aws_ecr_repository.backend.arn
      }
    ]
  })
}

resource "aws_iam_access_key" "s3_uploader" {
  user = aws_iam_user.s3_uploader.name
}

resource "aws_ecr_repository" "backend" {
  name                 = "tocopedia-backend"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = { Project = "tocopedia" }
}

resource "aws_ecr_lifecycle_policy" "backend" {
  repository = aws_ecr_repository.backend.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 5 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 5
      }
      action = { type = "expire" }
    }]
  })
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
