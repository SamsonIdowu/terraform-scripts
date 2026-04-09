region = "us-east-1"

instance_configs = [
  {
    name          = "ubuntu-node"
    instance_type = "t3.micro"
    ami           = "ami-xxxxxxxx" # Ubuntu 24.04 (add the actual AMI)
    ssh_user      = "ubuntu"
  },
  {
    name          = "centos-node"
    instance_type = "t3.small"
    ami           = "ami-yyyyyyyy" # CentOS Stream / AlmaLinux (add the actual AMI)
    ssh_user      = "ec2-user"
  }
]