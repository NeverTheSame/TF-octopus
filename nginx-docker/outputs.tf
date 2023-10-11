output "ec2_public_ip" {
    value = module.app-ec2-server.instance.public_ip
}