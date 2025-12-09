resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_cidr_block
    
    tags = {
        Name = "${var.project}-vpc"_
    }
}

resource "aws_subnet" "pub_subnet" {
  cidr_block = var.vpc_cidr_pub_subnet
  vpc_id     = aws_vpc.my_vpc.id
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
   tags = {
        Name = "${var.project}-pub-subnet"_
    }
}

resource "aws_subnet" "pri_subnet" {
  cidr_block = var.vpc_cidr_pri_subnet
  vpc_id     = aws_vpc.my_vpc.id
  availability_zone = "ap-south-1a"
  #map_public_ip_on_launch = true
   tags = {
        Name = "${var.project}-pri-subnet"_
    }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.project}-my-igw"
  }
}

resource "aws_default_route_table" "my_rt" {
  default_route_table_id = aws_vpc.my_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}