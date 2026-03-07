output "vm_public_ip" {
  value = azurerm_public_ip.vm_ip.ip_address
}

output "vm_private_key_path" {
  value = local_file.vm_private_key.filename
}
