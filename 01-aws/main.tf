terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = var.main_vpc_name
  }
}

# Create a Subnet
resource "aws_subnet" "web" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.10.0/24"

  tags = {
    "Name" = "Subnet"
  }
}

resource "aws_internet_gateway" "my_web_gtw" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "${var.main_vpc_name} IGW"
  }
}

resource "aws_default_route_table" "main_vpc_default_rt" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_web_gtw.id
  }

  tags = {
    "Name" = "My Default Route Table"
  }
}

resource "aws_default_security_group" "default_sec_group" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "Security groups"
  }
}

resource "aws_key_pair" "test_ssh_key" {
  key_name   = "test-key-terraform-course"
  public_key = file(var.ssh_key_path)
}

resource "aws_instance" "my_vm" {
  ami                         = "ami-05fa00d4c63e32376"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.web.id
  security_groups             = [aws_default_security_group.default_sec_group.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.test_ssh_key.key_name

  tags = {
    "Name" = "My EC2 Instance - Amazon Linux 2"
  }
}
