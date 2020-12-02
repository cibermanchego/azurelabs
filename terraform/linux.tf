#Resources for Logger VM

#Public IP
resource "azurerm_public_ip" "logger_public_ip" {
  name                = "logger-public-ip"
  location            = var.region
  resource_group_name = azurerm_resource_group.ncisglab.name
  allocation_method   = "Static"

  tags = {
    role = "logger"
  }
}

#NIC
resource "azurerm_network_interface" "logger_nic" {
  name = "logger-nic"
  location = var.region
  resource_group_name  = azurerm_resource_group.ncisglab.name
  #IP ADDRESS: 192.168.10.30
  ip_configuration {
    name                          = "Logger-NicConfiguration"
    subnet_id                     = azurerm_subnet.ncisglab_servers.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(var.servers_subnet_cidr, 30) # servers_subnet_cidr variable defined at vars.tf
    public_ip_address_id          = azurerm_public_ip.logger_public_ip.id
  }
}

#Generate random password 16 chars
# resource "random_password" "logger_password" {
#   length = 16
# }

#virtual machine resource
resource "azurerm_virtual_machine" "logger" {
  name                  = "logger"
  location              = azurerm_resource_group.ncisglab.location
  resource_group_name   = azurerm_resource_group.ncisglab.name
  network_interface_ids = [azurerm_network_interface.logger_nic.id]
  #
  vm_size               = "Standard_DS1_v2"
  # Image for CentOS
  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7_8"
    version   = "latest"
  }
  # Image for RHEL
#  storage_image_reference {
#    publisher = "RedHat"
#    offer     = "RHEL"
#    sku       = "7.8"
#    version   = "latest"
#  }
  # Disk
  # Delete OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true
  # Delete data disks automatically when deleting the VM
  delete_data_disks_on_termination = true
  storage_os_disk {
    name              = "logger-os-disk"
    create_option     = "FromImage"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "logger1"
    # Note: you can't use admin or Administrator in here, Azure won't allow you to do so :-)
    # Username set in vars.tf
    admin_username = var.logger_admin_user
    #password generated before
    admin_password = "Iniestademivida123!"
  }
  #Enable SSH
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      # path to public key in logger retrieves value from vars.tf for username
      path     = "/home/${var.logger_admin_user}/.ssh/authorized_keys"
      key_data = file(var.public_key_path)
    }
  }
  tags = {
    role = "logger"
  }
}