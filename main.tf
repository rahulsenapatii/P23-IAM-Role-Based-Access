terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_iam_role" "ec2_s3_role" {
  name = "project23-ec2-s3-role-rahul"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ec2.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "s3_read" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "profile" {
  name = "project23-profile-rahul"

  role = aws_iam_role.ec2_s3_role.name
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "project23_ec2" {
  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.profile.name

  tags = {
    Name = "project23-ec2-rahul"
  }
}
