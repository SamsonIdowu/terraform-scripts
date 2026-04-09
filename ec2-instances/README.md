This script does the following:

- Generates one shared SSH key pair (saved locally)
- Spins up multiple EC2 instances (different OS + sizes)
- Uses public DNS
- Locks down ingress access (only ports 22 & 443 are allowed)
- Keeps all instances in one subnet for internal communication
- Outputs ready-to-use SSH commands
- Uses explicit ssh_user

#### Note:
Modify the ec2 instance config in the `terraform.tfvars` file to change the instance properties.