data "aws_vpc" "def_vpc" {
  default = true
}

data "aws_subnet" "def_subnet" {
  vpc_id = data.aws_vpc.def_vpc.id
}

resource "aws_key_pair" "ssh" {
  key_name   = "ssh.pem"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "ssh" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "ssh.pem"
}

resource "aws_instance" "lamp_instance" {
  count           = 2
  ami             = "ami-094125af156557ca2"
  instance_type   = "t2.micro"
  key_name        = "ssh.pem"
  subnet_id       = data.aws_subnet.def_subnet.id
  security_groups = [aws_security_group.instance_sg.id]
  user_data       = file("lamp.sh")

  tags = {
    "Name" = "EC2 Instance ${count.index + 1}"
  }
}