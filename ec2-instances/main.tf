provider "aws" {
  region = var.region
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
  description = "Allow SSH on 2200 and HTTPS only"
  vpc_id      = aws_vpc.content-team-vpc.id

  # SSH on custom port 2200
  ingress {
    description = "SSH custom port"
    from_port   = 2200
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

  # Change SSH port to 2200
  #user_data = <<-EOF
  #            #!/bin/bash
  #            sed -i 's/^#Port 22/Port 2200/' /etc/ssh/sshd_config
  #            sed -i 's/^Port 22/Port 2200/' /etc/ssh/sshd_config
  #            systemctl restart sshd || systemctl restart ssh
  #            EOF
}