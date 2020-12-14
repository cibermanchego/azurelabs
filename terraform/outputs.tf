# output "dc_public_ip" {
#   value = azurerm_public_ip.dc_public_ip.ip_address
# }

# output "domain_controller_password" {
#   value = random_password.domain_controller_password.result
# }

#Output all public IPs of WS created
# output "ws_public_ips" {
#   value = azurerm_public_ip.ws_public_ip.*.ip_address
# }
# output "logger_public_ip" {
#   value = azurerm_public_ip.logger_public_ip.ip_address
# }

output "wef_public_ip" {
  value = azurerm_public_ip.wef_public_ip.ip_address
}
# output "workstations_rdp_commandline" {
#   value = {
#     for i in range(var.num_ws):
#     "workstation-${i + 1}" => "xfreerdp /v:${azurerm_public_ip.ws-[i]-public-ip.ip_address} /u:${var.windows_local_admin} /p:${var.windows_local_admin_password}  /w:1100 /h:650 +clipboard /cert-ignore"
#   }
# }

# output "what_next" {
#   value = <<EOF

# #############################
# ###  CREDENTIALS DETAILS  ###
# #############################

# - Domain Admin: domadmin / Itisfine123.
# - Local admin all windows: ${var.windows_local_admin} / ${var.windows_local_admin_password}
# - RDP Domain Controller: cmdkey /generic:"${azurerm_public_ip.dc_public_ip.ip_address}" /user:"${var.windows_local_admin}" /pass:"${var.windows_local_admin_password}"
#                         mstsc /v:${azurerm_public_ip.dc_public_ip.ip_address}
# - Login to logger box: ssh -i ${var.private_key_path} loggeradmin@${azurerm_public_ip.logger_public_ip.ip_address}


# EOF
# }

# output "logger_username" {
#   value = var.logger_admin_user
# }
#output "dc_user" {
#  value = azurerm_virtual_machine.domain_controller.admin_username
#}

# output "wef_password" {
#   value = random_password.wef_password.result
# }

# output "ws_password" {
#   value = random_password.ws_password.result
# }

