variable "aws_region" {
  default = "ap-southeast-2"
}
variable "name-prefix" {
  default = "svk"
}
variable "project" {
  default = "scaffold"
}
variable "vpc-a_cidr_block" {
  default = "10.100.0.0/16"
}
variable "vpc-a_subnet_1" {
  default = "10.100.1.0/24"
}
variable "key_name" {
  default = "svk-keypair"
}
variable "instance_type_linux_server" {
  default = "t2.micro"
}

data "aws_ami" "distro" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Fedora-Cloud-Base-37-1.5*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  # fedora owner
  owners = [ "125523088429" ]
}

