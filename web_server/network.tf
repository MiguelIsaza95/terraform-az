# multiple subnets with for_each
resource "azurerm_subnet" "web_server_subnet" {
  for_each             = var.subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.web_server_rg.name
  virtual_network_name = azurerm_virtual_network.web_server_vnet.name
  address_prefixes     = [each.value]
}

resource "azurerm_public_ip" "web_server_public_ip" {
  name                = "${var.server_name}-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.web_server_rg.name

  #conditional
  allocation_method = var.environment == "Prod" ? "Static" : "Dynamic"
}


#Not in use
# resource "azurerm_network_interface" "web_server_nic" {
#   count               = var.win_count
#   name                = "${var.server_name}-${format("%02d", count.index)}-nic"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.web_server_rg.name

#   ip_configuration {
#     name                          = "${var.server_name}-ip"
#     subnet_id                     = azurerm_subnet.web_server_subnet["web-server"].id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = count.index != 0 ? azurerm_public_ip.web_server_public_ip.id : null
#   }
# }