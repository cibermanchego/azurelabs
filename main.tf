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

# Subnet for servers 192.168.10.0/24
resource "azurerm_subnet" "ncisglab_servers" {
  name                 = "subnet-servers"
  resource_group_name  = azurerm_resource_group.ncisglab.name
  virtual_network_name = azurerm_virtual_network.intnet.name
  address_prefixes       = ["192.168.10.0/24"]
}

# Subnet for Workstations 192.168.20.0/24
resource "azurerm_subnet" "ncisglab_workstations" {
  name                 = "subnet-workstations"
  resource_group_name  = azurerm_resource_group.ncisglab.name
  virtual_network_name = azurerm_virtual_network.intnet.name
  address_prefixes       = ["192.168.20.0/24"]
}

#---------------------------
#Resources for DC
#Public IP
resource "azurerm_public_ip" "dc_public_ip" {
  name                = "dc-public-ip"
  location            = var.region
  resource_group_name = azurerm_resource_group.ncisglab.name
  allocation_method   = "Static"

  tags = {
    role = "dc"
  }
}

#NIC
resource "azurerm_network_interface" "dc_nic" {
  name = "dc-nic"
  location = var.region
  resource_group_name  = azurerm_resource_group.ncisglab.name

  ip_configuration {
    name                          = "DC-NicConfiguration"
    subnet_id                     = azurerm_subnet.ncisglab_servers.id
    private_ip_address_allocation = "Static"
    private_ip_address            = cidrhost(var.servers_subnet_cidr, 10)
    public_ip_address_id          = azurerm_public_ip.dc_public_ip.id
  }
}

