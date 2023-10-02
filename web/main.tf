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

resource "aws_instance" "ubuntu_machine" {
    ami = "ami-0f8e81a3da6e2510a"
    instance_type = "t2.micro"
    subnet_id = data.aws_subnet.kk-subnet-1.id
    tags = {
        Name = "${var.prefix}ubuntu-machine"
    }
}

output "ubuntu_machine_name" {
    value = aws_instance.ubuntu_machine.tags.Name
}