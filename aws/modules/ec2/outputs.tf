output "app_instance_id" {
  value = aws_instance.app.id
}

output "app_public_ip" {
  value = aws_eip.app_eip.public_ip
}

output "tools_instance_id" {
  value = aws_instance.tools.id
}

output "tools_public_ip" {
  value = aws_eip.tools_eip.public_ip
}
