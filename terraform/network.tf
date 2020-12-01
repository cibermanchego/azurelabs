#All common network resources are declared here
# Virtual network - Subnets - Network security Group - Network Security Group associations
#TODO Configure a 3 subnet and network security group for Logger. configure communication from server subnet to workstation subnet, currently is allow all
# Virtual network 192.168.0.0/16
resource "azurerm_virtual_network" "intnet" {
  name                = "internal_network"
  address_space       = ["192.168.0.0/16"]
  location            = azurerm_resource_group.ncisglab.location
  resource_group_name = azurerm_resource_group.ncisglab.name
}

# Subnet for servers 192.168.10.0/24
resource "azurerm_subnet" "ncisglab_servers" {
  name                 = "subnet_servers"
  resource_group_name  = azurerm_resource_group.ncisglab.name
  virtual_network_name = azurerm_virtual_network.intnet.name
  address_prefixes       = ["192.168.10.0/24"]
}

# Subnet for Workstations 192.168.20.0/24
resource "azurerm_subnet" "ncisglab_workstations" {
  name                 = "subnet_workstations"
  resource_group_name  = azurerm_resource_group.ncisglab.name
  virtual_network_name = azurerm_virtual_network.intnet.name
  address_prefixes       = ["192.168.20.0/24"]
}


# Network security group for Server subnet
resource "azurerm_network_security_group" "ncisglab_servers_nsg" {
  name                = "NCISGLab_servers_nsg"
  location = var.region
  resource_group_name  = azurerm_resource_group.ncisglab.name

  # SSH access
  security_rule {
    name                       = "ICMP"
    priority                   = 1009
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "ICMP"
    source_port_range          = "*"
    destination_port_range     = "*"
    # source_address_prefix      = "*"
    source_address_prefixes    = var.ip_whitelist
    destination_address_prefix = "*"
  }

  # SSH access
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    # source_address_prefix      = "*"
    source_address_prefixes    = var.ip_whitelist
    destination_address_prefix = "*"
  }

#   Splunk access
  security_rule {
    name                       = "Splunk"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8000"
    source_address_prefixes    = var.ip_whitelist
    destination_address_prefix = "*"
  }

  # RDP
  security_rule {
    name                       = "RDP"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefixes    = var.ip_whitelist
    destination_address_prefix = "*"
  }

  # WinRM
  security_rule {
    name                       = "WinRM"
    priority                   = 1005
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5985-5986"
    source_address_prefixes    = var.ip_whitelist
    destination_address_prefix = "*"
  }

  # Allow all traffic from the WS subnet REMOVE LATER
  security_rule {
    name                       = "WSSubnet"
    priority                   = 1007
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "192.168.20.0/24"
    destination_address_prefix = "*"
  }
 
# Guacamole access
#  security_rule {
# #   name                       = "Guacamole"
#    priority                   = 1008
#    direction                  = "Inbound"
#    access                     = "Allow"
#    protocol                   = "Tcp"
#    source_port_range          = "*"
#    destination_port_range     = "8080"
#   source_address_prefixes    = var.ip_whitelist
#    destination_address_prefix = "*"
#  }

}

# NSG association to servers subnet
resource "azurerm_subnet_network_security_group_association" "ncisglab_servers_nsga" {
  subnet_id                 = azurerm_subnet.ncisglab_servers.id
  network_security_group_id = azurerm_network_security_group.ncisglab_servers_nsg.id
}

# Network security group for Workstations subnet
resource "azurerm_network_security_group" "ncisglab_workstations_nsg" {
  name                = "NCISGLab_workstations_nsg"
  location = var.region
  resource_group_name  = azurerm_resource_group.ncisglab.name

# SSH access
  security_rule {
    name                       = "ICMP"
    priority                   = 1009
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "ICMP"
    source_port_range          = "*"
    destination_port_range     = "*"
    # source_address_prefix      = "*"
    source_address_prefixes    = var.ip_whitelist
    destination_address_prefix = "*"
  }

   # RDP
  security_rule {
    name                       = "RDP"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefixes    = var.ip_whitelist
    destination_address_prefix = "*"
  }

  # WinRM
  security_rule {
    name                       = "WinRM"
    priority                   = 1005
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5985-5986"
    source_address_prefixes    = var.ip_whitelist
    destination_address_prefix = "*"
  }

   # Allow all traffice from Server subnet REMOVE LATER
  security_rule {
    name                       = "ServersSubnet"
    priority                   = 1007
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "192.168.10.0/24"
    destination_address_prefix = "*"
  }

}

# NSG association to servers subnet
resource "azurerm_subnet_network_security_group_association" "ncisglab_workstations_nsga" {
  subnet_id                 = azurerm_subnet.ncisglab_workstations.id
  network_security_group_id = azurerm_network_security_group.ncisglab_workstations_nsg.id
}



# # Network security group for logger machine
# resource "azurerm_network_security_group" "ncisglab_logger_nsg" {
#   name                = "NCISGLab_logger_nsg"
#   location = var.region
#   resource_group_name  = azurerm_resource_group.ncisglab.name

#   # SSH access
#   security_rule {
#     name                       = "SSH"
#     priority                   = 1001
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     # source_address_prefix      = "*"
#     source_address_prefixes    = var.ip_whitelist
#     destination_address_prefix = "*"
#   }

# #   Splunk access
#   security_rule {
#     name                       = "Splunk"
#     priority                   = 1002
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "8000"
#     source_address_prefixes    = var.ip_whitelist
#     destination_address_prefix = "*"
#   }
# }