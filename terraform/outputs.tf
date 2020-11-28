output "dc_public_ip" {
  value = azurerm_public_ip.dc_public_ip.ip_address
}

output "domain_controller_password" {
  value = random_password.domain_controller_password.result
}

#output "dc_user" {
#  value = azurerm_virtual_machine.domain_controller.admin_username
#}
output "wef_public_ip" {
  value = azurerm_public_ip.wef_public_ip.ip_address
}
output "wef_password" {
  value = random_password.wef_password.result
}

output "ws_public_ip" {
  value = azurerm_public_ip.ws_public_ip.ip_address
}
output "ws_password" {
  value = random_password.ws_password.result
}

output "logger_public_ip" {
  value = azurerm_public_ip.ws_public_ip.ip_address
}
output "logger_password" {
  value = random_password.ws_password.result
}