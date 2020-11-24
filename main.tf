resource "azurerm_resource_group" "ncisglab" {
  name = "ncisglab-terraform"
  location = var.region
}

# Virtual network 192.168.0.0/16
resource "azurerm_virtual_network" "intnet" {
  name                = "internal-network"
  address_space       = ["192.168.0.0/16"]
  location            = azurerm_resource_group.ncisglab.location
  resource_group_name = azurerm_resource_group.ncisglab.name
}

# Subnet for servers
resource "azurerm_subnet" "ncisglab-servers" {
  name                 = "subnet-servers"
  resource_group_name  = azurerm_resource_group.ncisglab.name
  virtual_network_name = azurerm_virtual_network.intnet.name
  address_prefixes       = ["192.168.10.0/24"]
}

# Subnet for Wordstations
resource "azurerm_subnet" "ncisglab-workstations" {
  name                 = "subnet-workstations"
  resource_group_name  = azurerm_resource_group.ncisglab.name
  virtual_network_name = azurerm_virtual_network.intnet.name
  address_prefixes       = ["192.168.20.0/24"]
}