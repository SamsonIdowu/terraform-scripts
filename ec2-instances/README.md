## 🚀 Properties  

This script is built to spin up an AWS EC2 instance with ease:

- 🔑 Generates **one shared SSH key pair** (securely saved locally)  
- 🖥️ Launches **multiple EC2 instances** with different OS types and sizes  
- 🌐 Uses **public DNS names** for easy access  
- 🔒 Locks down ingress access (**only ports 22 & 443 allowed**)  
- 🏠 Keeps all instances in a **single subnet** for seamless internal communication  
- ⚡ Outputs **ready-to-use SSH commands**

---

### ⚠️ Note  
🛠️ You can easily customize your infrastructure by modifying the EC2 instance configurations in the `terraform.tfvars` file.
