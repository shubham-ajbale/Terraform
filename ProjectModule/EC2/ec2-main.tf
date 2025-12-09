provider "aws" {
  region = var.region
}

resource "aws_instance" "ec2_terraform" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "my-ec2"
  }
}
