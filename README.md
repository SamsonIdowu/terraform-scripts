# terraform-scripts
This repository hosts terraform scripts for different purposes

## Prerequisites
Run the following commands on powershell or CMD in admin mode:

### Install AWS CLI
1. Install AWS CLI v2 using `winget` utility:
```
winget install Amazon.AWSCLI
```
2. Verify the installation:
```
aws --version
```
3. Configure AWS CLI
```
aws configure
```
4. Enter your credentials when prompted:
```
AWS Access Key ID [None]: <YOUR_ACCESS_KEY>
AWS Secret Access Key [None]: <YOUR_SECRET_KEY>
Default region name [None]: us-east-1  # (or your preferred region)
Default output format [None]: json
```
The credentials are saved into: `C:\Users\<USER_ACCOUNT>\.aws\credentials` and `C:\Users\<USER_ACCOUNT>\.aws\config`
5. Verify your AWS configuration:
```
aws sts get-caller-identity
```

### Install Terraform
1. Install terrfaorm using `winget` utility:
```
winget install HashiCorp.Terraform
```
2. Verify the installation:
```
terraform --version
```

## Usage

- Clone the repository to your local machine using:
```
git clone https://github.com/SamsonIdowu/terraform-scripts.git
```
- Navigate to the project directory and your desired script. For example:
```
d terraform-scripts
cd ec2-instances
```
- Initialize the directory:
```
terraform init
```
- Show a plan of the changes to be deployed and save it to your working directory:
```
terraform plan -out .\tplan.txt
```
- Deploy the changes to AWS:
```
terraform apply --auto-configure
```
- Destroy the infrastructure:
```
terraform destroy --auto-configure
```