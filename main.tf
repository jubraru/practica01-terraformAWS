provider "aws" {
  region = "eu-west-3"
}

variable "ssh_key_path" {}

resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  public_key = file(var.ssh_key_path)
}

variable "availability_zone" {}
module "vpc" {
 source = "terraform-aws-modules/vpc/aws"
 name = "vpc-ejercicio1"
 cidr = "10.0.0.0/16"
 azs = [var.availability_zone]
 private_subnets = ["10.0.0.0/24", "10.0.1.0/24"]
 public_subnets = ["10.0.100.0/24", "10.0.101.0/24"]
 enable_dns_hostnames = true
 enable_dns_support = true
 enable_nat_gateway = false
 enable_vpn_gateway = false
 tags = { Terraform = "true", Environment = "dev" }
}

resource "aws_security_group" "allow_ssh" {
 name = "allow_ssh"
 description = "Allow SSH inbound traffic"
 vpc_id = module.vpc.vpc_id
 #ingress
  ingress {
    description = "SSH from VPC"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 # egress
 egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
 }
 tags = {
  Name = "allow_ssh"
 }
}

resource "aws_security_group" "allow_http" {
 name = "allow_http"
 description = "Allow HTTP inbound traffic"
 vpc_id = module.vpc.vpc_id
 #ingress
  ingress {
    description = "HTTP from VPC"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 # egress
 egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
 }
 tags = {
  Name = "allow_http"
 }
}
resource "aws_security_group" "allow_https" {
 name = "allow_https"
 description = "Allow HTTPS inbound traffic"
 vpc_id = module.vpc.vpc_id
 #ingress
  ingress {
    description = "HTTPS from VPC"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 # egress
 egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
 }
 tags = {
  Name = "allow_https"
 }
}

output "ip_instance" {
  value = aws_instance.web.public_ip
}

output "ssh" {
  value = "ssh -l ubuntu ${aws_instance.web.public_ip}"
}