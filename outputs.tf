output "dc_public_ip" {
  value = azurerm_public_ip.dc_public_ip.ip_address
}
output "dc_private_ip" {
  value = azurerm_network_interface.dc_nic.private_ip_address
}

