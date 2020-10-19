provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "web_server_rg" {
  name     = "${var.resource_group}_${var.environment}"
  location = var.location

  tags = {
    environment = local.build_environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_virtual_network" "web_server_vnet" {
  name                = "${var.resource_group}-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.web_server_rg.name
  address_space       = [var.network]
}

module "bastion_host" {
  source = "./modules/bastion"
  name = var.bastion_rg
  location = var.location
  subnet_id =  azurerm_subnet.web_server_subnet["az-bastion"].id
}