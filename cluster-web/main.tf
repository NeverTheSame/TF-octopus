provider "aws" {
    # ~/.aws/credentials
    region = "us-west-1"
}


variable "server_port" {
    description = "The port the server will use for HTTP requests"
    type = number
}


variable "prefix" {
    description = "prefix for all deployed resources"
}


resource "aws_security_group" "ec2-sg" {
  name = "${var.prefix}-ec2-sg"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_launch_configuration" "launch-config" {
  image_id        = "ami-0f8e81a3da6e2510a"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.ec2-sg.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  # Required when using a launch configuration with an auto scaling group.
  lifecycle {
    create_before_destroy = true
  }
}


data "aws_vpc" "default-vpc" {
  default = true
}


data "aws_subnets" "default-subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default-vpc.id]
  }
}


resource "aws_autoscaling_group" "asg" {
  launch_configuration = aws_launch_configuration.launch-config.name
  vpc_zone_identifier  = data.aws_subnets.default-subnets.ids

  target_group_arns = [aws_lb_target_group.lb-tg.arn]
  health_check_type = "ELB"

  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "${var.prefix}-asg"
    propagate_at_launch = true
  }
}


resource "aws_lb" "load-balancer" {
  name               = "${var.prefix}-lb"

  load_balancer_type = "application"
  subnets            = data.aws_subnets.default-subnets.ids
  security_groups    = [aws_security_group.alb.id]
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.load-balancer.arn
  port              = 80
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}


resource "aws_lb_target_group" "lb-tg" {
  name = "${var.prefix}-lb-tg"

  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default-vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}


resource "aws_lb_listener_rule" "lb-listener-rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-tg.arn
  }
}


resource "aws_security_group" "alb" {
  name = "${var.prefix}-alb"

  # Allow inbound HTTP requests
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


output "alb_dns_name" {
    value = aws_lb.load-balancer.dns_name
    description = "The domain name of the load balancer"
}


output "aws_subnets" {
    value       = data.aws_subnets.default-subnets.ids
}