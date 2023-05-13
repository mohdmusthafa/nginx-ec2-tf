
provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket = "web-infra-tf-state-01"
    key = "terraform.tfstate"
    region = "ap-south-1"
  }
}

resource "aws_security_group" "web" {
  name_prefix = "web-"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami = "ami-0a5dcff6fb7af3fc9"
  instance_type = "t4g.nano"
  key_name = "tflinux"

  user_data = file("user_data.sh")

  vpc_security_group_ids = [aws_security_group.web.id]

  tags = {
    Name = "web-server"
    Environment = "Development"
  }
}

output "public_ip" {
  value = aws_instance.web.public_ip
}