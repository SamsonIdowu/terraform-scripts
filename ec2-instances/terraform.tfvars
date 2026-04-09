region = "us-east-1"

instance_configs = [
  # Ubuntu 24.04 LTS on t3.medium
  {
    name          = "ubuntu-node"
    instance_type = "t3.medium"
    ami           = "resolve:ssm:/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
    ssh_user      = "ubuntu"
  },

  # CentOS Stream 10 on t3.medium
  {
    name          = "centos-node"
    instance_type = "t3.medium"
    ami           = "ami-052739141bbd45b53"
    ssh_user      = "ec2-user"
  }
]