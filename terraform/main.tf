
provider "aws" {
  region = var.region
}

resource "aws_iam_role" "stream_project_role" {
  name = var.iam_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "project_s3_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.stream_project_role.name
}

resource "aws_iam_role_policy_attachment" "project_ec2_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.stream_project_role.name
}

resource "aws_iam_role_policy_attachment" "project_ssm_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  role       = aws_iam_role.stream_project_role.name
}

resource "tls_private_key" "kafka_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.kafka_key_name
  public_key = tls_private_key.kafka_key.public_key_openssh
}

resource "local_file" "kafka_key_local" {
  content  = tls_private_key.kafka_key.private_key_pem
  filename = pathexpand("~/.ssh/spotify_stream_kafka_key.pem")
}

resource "aws_security_group" "security_group" {
  name = "allow_connections"

  ingress {
    description = "SSH from the internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "80 from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.stream_project_role.name
}

resource "aws_instance" "kafka_instance" {
  ami                         = "ami-0d1ddd83282187d18"
  instance_type               = "t2.micro"
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.security_group.id]
  key_name                    = aws_key_pair.generated_key.key_name
  user_data                   = file("../setup/kafka.sh")
  tags = {
    Name = "kafka"
  }
  provisioner "local-exec" {
    command = <<EOT
      echo "Host spotify-stream-kafka
        HostName ${aws_instance.kafka_instance.public_ip}
        User ubuntu
        IdentityFile ${local_file.kafka_key_local.filename}" \
      >> ~/.ssh/config
    EOT
  }
}

resource "aws_ssm_parameter" "spotify_client_id" {
  name        = "/spotify-streaming/client_id"
  description = "Spotify API client id"
  type        = "String"
  value       = var.spotify_client_id
  overwrite   = true
}

resource "aws_ssm_parameter" "spotify_client_secret" {
  name        = "/spotify-streaming/client_secret"
  description = "Spotify API client secret"
  type        = "String"
  value       = var.spotify_client_secret
  overwrite   = true
}

resource "aws_ssm_parameter" "spotify_redirect_uri" {
  name        = "/spotify-streaming/redirect_uri"
  description = "Spotify API redirect URI"
  type        = "String"
  value       = var.spotify_redirect_uri
  overwrite   = true
}

output "instance_public_ip" {
  value = aws_instance.kafka_instance.public_ip
}

output "instance_private_ip" {
  value = aws_instance.kafka_instance.private_ip
}
