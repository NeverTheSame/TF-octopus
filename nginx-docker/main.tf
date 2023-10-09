provider "aws" {
    # ~/.aws/credentials
    region = "us-west-1"
}

variable vpc_cidr_block{}
variable subnet_cidr_block{}
variable prefix {}
variable avail_zone {}
variable "my_ip" {
    type = string
}

# Network and Security
resource "aws_vpc" "kk-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = "${var.prefix}-vpc"
    }
}

resource "aws_subnet" "kk-subnet" {
    vpc_id = aws_vpc.kk-vpc.id
    cidr_block = var.subnet_cidr_block
    tags = {
        Name = "${var.prefix}-subnet"
    }
}

resource "aws_internet_gateway" "kk-igw" {
    # Acts as a virtual modem
    vpc_id = aws_vpc.kk-vpc.id
    tags = {
        Name = "${var.prefix}-igw"
    }
}

resource "aws_default_route_table" "main-route-table" {
    default_route_table_id = aws_vpc.kk-vpc.default_route_table_id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.kk-igw.id
    }
    tags = {
        Name = "${var.prefix}-main-route-table"
    }
}

resource "aws_default_security_group" "default-sg" {
    vpc_id      = aws_vpc.kk-vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.my_ip]
    }

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }

    tags = {
        Name: "${var.prefix}-default-sg"
    }
}

# Compute
variable instance_type {}
variable public_key_location {}

data "aws_ami" "latest-amazon-linux-2023-image" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["al2023-ami-2023.2.*-x86_64"]
    }
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}

resource "aws_key_pair" "ssh-key" {
    key_name = "${var.prefix}-key-pair"
    public_key = file(var.public_key_location)
    tags = {
        Name = "${var.prefix}-key-pair"
    }
}

resource "aws_instance" "kk-ec2" {
    ami = data.aws_ami.latest-amazon-linux-2023-image.id
    instance_type = var.instance_type

    subnet_id = aws_subnet.kk-subnet.id
    vpc_security_group_ids = [aws_default_security_group.default-sg.id]
    availability_zone = var.avail_zone

    associate_public_ip_address = true

    # to connect: ssh -i ~/.ssh/id_rsa  ec2-user@public_ip
    key_name = aws_key_pair.ssh-key.key_name

    tags = {
        Name = "${var.prefix}-server"
    }

    user_data = file("user-data.sh")
    user_data_replace_on_change = true
}

output "ec2_public_ip" {
    value = aws_instance.kk-ec2.public_ip
}
