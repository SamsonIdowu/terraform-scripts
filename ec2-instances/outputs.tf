output "private_key_path" {
  value = local_file.private_key.filename
}

output "instance_public_dns" {
  description = "Public DNS names of instances"
  value = [
    for i in aws_instance.ec2_instances :
    i.public_dns
  ]
}

output "ssh_commands" {
  description = "Ready-to-use SSH commands"
  value = [
    for idx, i in aws_instance.ec2_instances :
    "ssh -i ec2_key.pem ${var.instance_configs[idx].ssh_user}@${i.public_dns} -p 2200"
  ]
}