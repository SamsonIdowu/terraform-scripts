# 🌍 terraform-scripts  
This repository hosts a collection of **Terraform scripts** designed to automate and simplify different infrastructure use cases. ⚡  

---

## 🧰 Prerequisites  
Run the following commands on **PowerShell or CMD (Admin mode)**:

---

### ☁️ Install AWS CLI  

### Install AWS CLI
1. Install AWS CLI v2 using `winget`:
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

📁 Credentials will be saved in:  
- `C:\Users\<USER_ACCOUNT>\.aws\credentials`  
- `C:\Users\<USER_ACCOUNT>\.aws\config`  

5. Verify your configuration:  
5. Verify your AWS configuration:
```
aws sts get-caller-identity
```


---

### 🏗️ Install Terraform  

1. Install Terraform using `winget`:  
```
winget install HashiCorp.Terraform
```
2. Verify the installation:
```
terraform --version
```

## 🚀 Usage  

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


---

## ⚠️ Notes  

- 🔐 Always keep your AWS credentials secure — never commit them to Git.  
- 🧪 Review your `terraform plan` output carefully before applying changes.  
- 💡 Customize scripts based on your infrastructure needs for better control and efficiency.  
