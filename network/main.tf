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

resource "aws_vpc" "kk-vpc" {
    cidr_block = var.cidr_blocks[0].cidr_block
    tags = {
      Name = "${var.prefix}${var.cidr_blocks[0].name}"
    }
}

resource "aws_subnet" "kk-subnet-1" {
    vpc_id = aws_vpc.kk-vpc.id
    cidr_block = var.cidr_blocks[1].cidr_block
    availability_zone = "us-west-1b"
    tags = {
      Name = "${var.prefix}${var.cidr_blocks[1].name}"
    }
}

data "aws_vpc" "existing_vpc" {
    default = true
}

resource "aws_subnet" "kk-subnet-2" {
    vpc_id = data.aws_vpc.existing_vpc.id
    cidr_block = var.cidr_blocks[2].cidr_block
    availability_zone = "us-west-1b"
    tags = {
      Name = "${var.prefix}${var.cidr_blocks[2].name}"
    }
}

output "vpc-id" {
    value = aws_vpc.kk-vpc.tags.Name
}

output "subnet-1-id" {
    value = aws_subnet.kk-subnet-1.tags.Name
}

output "subnet-2-id" {
    value = aws_subnet.kk-subnet-2.tags.Name
}


