provider "aws" {
    # ~/.aws/credentials
    region = "us-west-1"
}

# Network and Security
resource "aws_vpc" "kk-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = "${var.prefix}-vpc"
    }
}

module "app-subnet" {
    source = "./modules/subnet"
    subnet_cidr_block = var.subnet_cidr_block
    avail_zone = var.avail_zone
    prefix = var.prefix
    vpc_id = aws_vpc.kk-vpc.id
    default_route_table_id = aws_vpc.kk-vpc.default_route_table_id
}

module "app-ec2-server" {
    source = "./modules/webserver"
    vpc_id = aws_vpc.kk-vpc.id
    my_ip = var.my_ip
    prefix = var.prefix
    image_name = var.image_name
    public_key_location = var.public_key_location
    instance_type = var.instance_type
    subnet_id = module.app-subnet.subnet.id
    avail_zone = var.avail_zone
}
