output "dc_public_ip" {
  value = azurerm_public_ip.dc_public_ip.ip_address
}

# output "domain_controller_password" {
#   value = random_password.domain_controller_password.result
# }

#Output all public IPs of WS created
output "ws_public_ips" {
  value = azurerm_public_ip.ws_public_ip.*.ip_address
}
output "logger_public_ip" {
  value = azurerm_public_ip.logger_public_ip.ip_address
}

output "what_next" {
  value = <<EOF
#############################
###  CREDENTIALS DETAILS  ###
#############################

- Domain Admin: domadmin / Ncisglab123.
- Local admin all windows: andres / Iniestademivida123!
- Login to logger box: ssh -i ~\.ssh\id_logger loggeradmin@logger_plublic_ip


EOF
}

# output "logger_username" {
#   value = var.logger_admin_user
# }
#output "dc_user" {
#  value = azurerm_virtual_machine.domain_controller.admin_username
#}
# output "wef_public_ip" {
#   value = azurerm_public_ip.wef_public_ip.ip_address
# }
# output "wef_password" {
#   value = random_password.wef_password.result
# }

# output "ws_password" {
#   value = random_password.ws_password.result
# }

