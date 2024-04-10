provider "aws" {
  region = "eu-west-3"
  # access_key = "PUT-YOUR-ACCESS-KEY"
  # secret_key = "PUT-YOUR-SECRET-KEY"
}

resource "aws_instance" "web" {
  ami           = "ami-00c71bd4d220aa22a"
  instance_type = "t2.micro"
  key_name      = "ais-key-pair"

  tags = {
    Name = "ais-instance-terraform"
  }

  root_block_device {
    delete_on_termination = true
  }

}