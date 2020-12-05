#All Windows VMs and their resources are declared here

#Resources for DC

#Public IP
resource "azurerm_public_ip" "dc_public_ip" {
  name                = "dc-public-ip"
  location            = var.region
  resource_group_name = azurerm_resource_group.ncisglab.name
  allocation_method   = "Static"
  tags = {
    role = "domain-controller"
  }
}

#NIC
resource "azurerm_network_interface" "dc_nic" {
  name = "dc-nic"
  location = var.region
  resource_group_name  = azurerm_resource_group.ncisglab.name
  #IP ADDRESS: 192.168.10.10
  ip_configuration {
    name                          = "DC-NicConfiguration"
    subnet_id                     = azurerm_subnet.ncisglab_servers.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(var.servers_subnet_cidr, 10) # servers_subnet_cidr variable defined at vars.tf
    public_ip_address_id          = azurerm_public_ip.dc_public_ip.id
  }
}

#VM
#Generate random password 16 chars
# resource "random_password" "domain_controller_password" {
#   length = 16
# }

#virtual machine resource
resource "azurerm_virtual_machine" "domain_controller" {
  name                  = "domain-controller"
  location              = azurerm_resource_group.ncisglab.location
  resource_group_name   = azurerm_resource_group.ncisglab.name
  network_interface_ids = [azurerm_network_interface.dc_nic.id]
  # List of available sizes: https://docs.microsoft.com/en-us/azure/cloud-services/cloud-services-sizes-specs
  vm_size               = "Standard_D1_v2"
  # Base image
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  
  # Disk
  # Delete OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true
  # Delete data disks automatically when deleting the VM
  delete_data_disks_on_termination = true
  storage_os_disk {
    name              = "domain-controller-os-disk"
    create_option     = "FromImage"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "dc1"
    # Note: you can't use admin or Administrator in here, Azure won't allow you to do so :-)
    admin_username = "andres"
    #password generated before
    #admin_password = random_password.domain_controller_password.result
    #Change to hardcoded password
    admin_password = "Iniestademivida123!"
  }
  #Enable WINRM
  os_profile_windows_config {
      enable_automatic_upgrades = false
      timezone = "Central European Standard Time"
      winrm {
        protocol = "HTTP"
      }
  }
  tags = {
    role = "domain-controller"
  }
}


# #-------------------------------

# # #Resources for WEF VM

# #Public IP
# resource "azurerm_public_ip" "wef_public_ip" {
#   name                = "wef-public-ip"
#   location            = var.region
#   resource_group_name = azurerm_resource_group.ncisglab.name
#   allocation_method   = "Static"

#   tags = {
#     role = "wef"
#   }
# }

# #NIC
# resource "azurerm_network_interface" "wef_nic" {
#   name = "wef-nic"
#   location = var.region
#   resource_group_name  = azurerm_resource_group.ncisglab.name
#   #IP ADDRESS: 192.168.10.20
#   ip_configuration {
#     name                          = "WEF-NicConfiguration"
#     subnet_id                     = azurerm_subnet.ncisglab_servers.id
#     private_ip_address_allocation = "Static"
#     private_ip_address            = cidrhost(var.servers_subnet_cidr, 20) # servers_subnet_cidr variable defined at vars.tf
#     public_ip_address_id          = azurerm_public_ip.wef_public_ip.id
#   }
# }

# #Generate random password 16 chars
# resource "random_password" "wef_password" {
#   length = 16
# }

# #virtual machine resource
# resource "azurerm_virtual_machine" "wef" {
#   name                  = "wef"
#   location              = azurerm_resource_group.ncisglab.location
#   resource_group_name   = azurerm_resource_group.ncisglab.name
#   network_interface_ids = [azurerm_network_interface.wef_nic.id]
#   # List of available sizes: https://docs.microsoft.com/en-us/azure/cloud-services/cloud-services-sizes-specs
#   vm_size               = "Standard_D1_v2"
#   # Base image
#   storage_image_reference {
#     publisher = "MicrosoftWindowsServer"
#     offer     = "WindowsServer"
#     sku       = "2019-Datacenter"
#     version   = "latest"
#   }
  
#   # Disk
#   # Delete OS disk automatically when deleting the VM
#   delete_os_disk_on_termination = true
#   # Delete data disks automatically when deleting the VM
#   delete_data_disks_on_termination = true
#   storage_os_disk {
#     name              = "wef-os-disk"
#     create_option     = "FromImage"
#     caching           = "ReadWrite"
#     managed_disk_type = "Standard_LRS"
#   }
#   os_profile {
#     computer_name  = "wef"
#     # Note: you can't use admin or Administrator in here, Azure won't allow you to do so :-)
#     admin_username = "andres"
#     #password generated before
#          
#     #admin_password = random_password.wef_password.result
#     #hardcoded password
#     admin_password = "Iniestademivida123!"
#   }
#   #Enable WINRM
#   os_profile_windows_config {
#       enable_automatic_upgrades = false
#       timezone = "Central European Standard Time"
#       winrm {
#         protocol = "HTTP"
#       }
#   }
#   tags = {
#     role = "wef"
#   }
# }

# #-------------------------------

# #Resources for Windows 10 VM

#Public IP 1 per WS
resource "azurerm_public_ip" "ws_public_ip" {
  count = var.num_ws #index
  name                = "ws-${count.index + 1}-public-ip"
  location            = var.region
  resource_group_name = azurerm_resource_group.ncisglab.name
  allocation_method   = "Static"

  tags = {
    role = "workstation"
  }
}

#NIC 1 per WS
resource "azurerm_network_interface" "ws_nic" {
  count = var.num_ws #index
  name = "ws-${count.index + 1}-nic"
  location = var.region
  resource_group_name  = azurerm_resource_group.ncisglab.name
  #IP ADDRESS: 192.168.20.10
  ip_configuration {
    name                          = "WS-NicConfiguration"
    subnet_id                     = azurerm_subnet.ncisglab_workstations.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(var.workstations_subnet_cidr, 10 + count.index) # workstations_subnet_cidr variable defined at vars.tf, host 10 + index
    public_ip_address_id          = azurerm_public_ip.ws_public_ip[count.index].id #IP by index
  }
}

#Generate random password 16 chars
# resource "random_password" "ws_password" {
#   length = 16
# }

#virtual machine resource
resource "azurerm_virtual_machine" "ws" {
  count = var.num_ws
  name                  = "ws${count.index + 1}" #Name as ws + index
  location              = azurerm_resource_group.ncisglab.location
  resource_group_name   = azurerm_resource_group.ncisglab.name
  network_interface_ids = [azurerm_network_interface.ws_nic[count.index].id] #NIC assign by index
  # https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-b-series-burstable
  vm_size               = "Standard_B1s"
  # Base image VM Gen 2 https://docs.microsoft.com/en-us/azure/virtual-machines/generation-2
  storage_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-10"
    sku       = "19h2-pro-g2"
    version   = "latest"
  }

  # Disk
  # Delete OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true
  # Delete data disks automatically when deleting the VM
  delete_data_disks_on_termination = true
  storage_os_disk {
    name              = "ws-${count.index + 1}-os-disk"
    create_option     = "FromImage"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "ws${count.index + 1}" #set hostname same as name of VM
    # Note: you can't use admin or Administrator in here, Azure won't allow you to do so :-)
    admin_username = "andres"
    #password hardcoded
    admin_password = "Iniestademivida123!"
  }
  #Enable WINRM
  os_profile_windows_config {
      enable_automatic_upgrades = false
      timezone = "Central European Standard Time"
      winrm {
        protocol = "HTTP"
      }
  }
  tags = {
    role = "workstation"
  }
}
