provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.40"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.2"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.8"
    }
  }
  required_version = ">= 1.5"
}

# -------------------------
# Generate SSH Key Pair
# -------------------------
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/ec2_key.pem"
  file_permission = "0600"
}

resource "aws_key_pair" "generated_key" {
  key_name   = "shared-ec2-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# -------------------------
# Networking (VPC)
# -------------------------
resource "aws_vpc" "content-team-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true 

  tags = {
    Name = "content-team-vpc"
  }
}

resource "aws_subnet" "shared_subnet" {
  vpc_id                  = aws_vpc.content-team-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "shared-subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.content-team-vpc.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.content-team-vpc.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "assoc" {
  subnet_id      = aws_subnet.shared_subnet.id
  route_table_id = aws_route_table.rt.id
}

# -------------------------
# Security Group
# -------------------------
resource "aws_security_group" "secure_sg" {
  name        = "secure-sg"
  description = "Allow SSH on 22 and HTTPS only"
  vpc_id      = aws_vpc.content-team-vpc.id

  # ✅ Standard SSH port
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    description = "HTTPS access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Internal communication inside VPC
  ingress {
    description = "Internal VPC traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.content-team-vpc.cidr_block]
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------------
# EC2 Instances
# -------------------------
resource "aws_instance" "ec2_instances" {
  count = length(var.instance_configs)
  ami           = var.instance_configs[count.index].ami
  instance_type = var.instance_configs[count.index].instance_type
  subnet_id              = aws_subnet.shared_subnet.id
  vpc_security_group_ids = [aws_security_group.secure_sg.id]
  key_name               = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true

  tags = {
    Name = var.instance_configs[count.index].name
  }

}