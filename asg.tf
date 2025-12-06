resource "aws_launch_template" "demo-template" {
  name_prefix   = "demo-template"
  image_id      = "ami-02b8269d5e85954ef"
  instance_type = "t3.micro"

  user_data = base64encode(<<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo systemctl enable apache2
                echo "Hello, World!" > /var/www/html/index.html
                EOF
)
}

resource "aws_autoscaling_group" "bar" {
  availability_zones = ["ap-south-1a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.demo-template.id
    version = "$Latest"
  }
}

