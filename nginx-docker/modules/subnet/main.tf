resource "aws_subnet" "kk-subnet" {
    vpc_id = var.vpc_id
    cidr_block = var.subnet_cidr_block
    tags = {
        Name = "${var.prefix}-subnet"
    }
}

resource "aws_internet_gateway" "kk-igw" {
    # Acts as a virtual modem
    vpc_id = var.vpc_id
    tags = {
        Name = "${var.prefix}-igw"
    }
}

resource "aws_default_route_table" "main-route-table" {
    default_route_table_id = var.default_route_table_id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.kk-igw.id
    }
    tags = {
        Name = "${var.prefix}-main-route-table"
    }
}