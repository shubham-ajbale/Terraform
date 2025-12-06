provider "aws" {
    region = "ap-south-1"
  
}

resource "aws_s3_bucket" "demo1" {
  bucket = "my-tf-test-bucket1-shubham-12345"

  tags = {
    Name        = "my-vivo-oppo-10-munni-10"
    Environment = "Dev"
  }
}

resource "aws_s3_object" "object1" {
  bucket = "my-tf-test-bucket1-shubham-12345"
  key    = "file.txt"
  source = "/root/file.txt"

  
}
