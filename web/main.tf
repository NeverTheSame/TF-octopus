provider "aws" {
    # ~/.aws/credentials
    region = "us-west-1"
}

variable "prefix" {
    description = "prefix for all deployed resources"
}

variable "cidr_blocks" {
    description = "cidr blocks and name tags for vpc(0) and subnets(1,2)"
    type = list(object({
        cidr_block = string
        name = string
    }))
}

data "aws_vpc" "kk-vpc" {
    default = false
    filter {
        name = "tag:Name"
        values = ["${var.prefix}${var.cidr_blocks[0].name}"]
    }
}

data "aws_subnet" "kk-subnet-1" {
    vpc_id = data.aws_vpc.kk-vpc.id
    cidr_block = var.cidr_blocks[1].cidr_block
    availability_zone = "us-west-1b"
    tags = {
      Name = "${var.prefix}${var.cidr_blocks[1].name}"
    }
}

resource "aws_security_group" "security_group" {
    description = "Allows the EC2 Instance to receive traffic on port 8080"
    name = "${var.prefix}security-group"

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "ubuntu_machine" {
    ami = "ami-0f8e81a3da6e2510a"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.security_group.id]

    user_data = <<EOF
              #!/bin/bash
              echo "Hello, World" > index.xhtml
              nohup busybox httpd -f -p 8080 &
              EOF
    # When you change the user_data parameter and run apply, Terraform will terminate the original instance  
    # and launch a totally new one.
    user_data_replace_on_change = true
    tags = {
        Name = "${var.prefix}ubuntu-machine"
    }
}

output "ubuntu_machine_name" {
    value = aws_instance.ubuntu_machine.public_ip
}