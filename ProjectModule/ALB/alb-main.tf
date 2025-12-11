provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "my_sg" {
  name        = "my-security-group"
  description = "My security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-security-group"
  }
}

resource "aws_lb_target_group" "tg_home" {
  name     = "tg-home"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group" "tg_mobile" {
  name     = "tg-mobile"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/mobile/"
  }
}

resource "aws_lb_target_group" "tg_laptop" {
  name     = "tg-laptop"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/laptop/"
  }
}

resource "aws_lb" "my_lb" {
  name               = "my-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my_sg.id]
  subnets            = [var.subnet_id_1, var.subnet_id_2]

  tags = {
    app = "my-app"
    env = "dev"
  }
}

resource "aws_lb_listener" "my_lb_listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_home.arn
  }
}

resource "aws_lb_listener_rule" "my_lb_listener_rule_laptop" {
  listener_arn = aws_lb_listener.my_lb_listener.arn
  priority     = 101

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_laptop.arn
  }

  condition {
    path_pattern {
      values = ["/laptop*"]
    }
  }
}

resource "aws_lb_listener_rule" "my_lb_listener_rule_mobile" {
  listener_arn = aws_lb_listener.my_lb_listener.arn
  priority     = 102

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_mobile.arn
  }

  condition {
    path_pattern {
      values = ["/mobile*"]
    }
  }
}
