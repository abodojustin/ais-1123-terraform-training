provider "aws" {
  region = "eu-west-3"
}

data "aws_ami" "amazon_ami_most_recent" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

}

resource "aws_instance" "ais_ec2" {
  ami           = data.aws_ami.amazon_ami_most_recent.id
  instance_type = var.instancetype
  key_name      = "ais-key-pair"

  tags = var.aws_common_tag

  root_block_device {
    delete_on_termination = true
  }

}

resource "aws_security_group" "allow_http_https" {
  name        = "allow_http_https"
  description = "Allow http & https inbound traffic"

  ingress {
    description = "allow http from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow https from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "lb" {
  instance = aws_instance.ais_ec2.id
  domain   = "vpc"
}