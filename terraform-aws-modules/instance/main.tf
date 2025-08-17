terraform {
  required_version = ">= 1.12.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.9.0"
    }
  }
}

locals {
  user_data_file = var.user_data_file != null ? var.user_data_file : "${path.module}/user_data.sh"
}

data "aws_ami" "amazon_linux" {
  owners      = ["137112412989"]
  most_recent = true
  name_regex  = "al2023-ami-\\d{4}.\\d.\\d{8}.\\d-kernel-6.1-x86_64"
}

resource "aws_instance" "server" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id
  security_groups = var.security_groups
  user_data       = file(local.user_data_file)
  tags = merge(var.tags, {
    Name = "[${var.tags.Project}] ${var.name}"
  })
}
