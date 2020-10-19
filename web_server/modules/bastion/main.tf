provider "azurerm" {
  version = "2.2.0"
  features {}
}

resource "azurerm_resource_group" "bastion_rg" {
  name     = var.bastion_rg
  location = var.location
}

resource "azurerm_public_ip" "bastion_pip" {
  name                = "bastion-pip"
  resource_group_name = azurerm_resource_group.bastion_rg.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion_host" {
  name                = "bastion-host"
  resource_group_name = azurerm_resource_group.bastion_rg.name  
  location            = var.location

  ip_configuration {
    name                 = "us2w"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}