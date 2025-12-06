provider "aws" {
    region = "ap-south-1"
  
}


resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}


resource "aws_route_table" "example" {
  vpc_id = aws_vpc.main.id

  route = []

  tags = {
    Name = "example"
  }
}
