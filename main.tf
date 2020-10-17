provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "web_server_sg" {
  name     = "${var.resource_group}_${var.environment}"
  location = var.location

  tags = {
    environment = local.build_environment
  }
}

resource "azurerm_virtual_network" "web_server_vnet" {
  name                = "${var.resource_group}-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.web_server_sg.name
  address_space       = [var.network]
}