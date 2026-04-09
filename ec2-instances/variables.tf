variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "instance_configs" {
  description = "EC2 instances configuration"
  type = list(object({
    name           = string
    instance_type  = string
    ami            = string
    ssh_user       = string
  }))
}