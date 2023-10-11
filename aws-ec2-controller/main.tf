provider "aws" {
    region = "us-west-2"
}

resource "aws_ec2_instance_state" "windows-instance-state" {
  instance_id = var.instance_id
  state = var.state
}

data "aws_instance" "windows-instance" {
    instance_id = aws_ec2_instance_state.windows-instance-state.instance_id
}

output "instance_public_ip" {
    value = data.aws_instance.windows-instance.public_ip
}