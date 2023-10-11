provider "aws" {
    # ~/.aws/credentials
    region = "us-west-1"
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.prefix}-vpc"
  cidr = var.vpc_cidr_block

  azs             = [var.avail_zone]
  public_subnets  = [var.subnet_cidr_block]

  tags = {
    Name = "${var.prefix}-vpc"
  }

  public_subnet_tags = {
    Name = "${var.prefix}-public-subnet"
  }
}

module "app-ec2-server" {
    source = "./modules/webserver"
    vpc_id = module.vpc.vpc_id
    my_ip = var.my_ip
    prefix = var.prefix
    image_name = var.image_name
    public_key_location = var.public_key_location
    instance_type = var.instance_type
    subnet_id = module.vpc.public_subnets[0]
    avail_zone = var.avail_zone
}
