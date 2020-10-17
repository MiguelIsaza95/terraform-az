resource "azurerm_network_security_group" "web_server_nsg" {
  name                = "${var.server_name}-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.web_server_sg.name
}

resource "azurerm_network_security_rule" "web_server_ng_rule_rdp" {
  resource_group_name         = azurerm_resource_group.web_server_sg.name
  network_security_group_name = azurerm_network_security_group.web_server_nsg.name
  name                        = "RDP inbound"
  priority                    = 100
  direction                   = "inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# Attach sg to an interface id
# resource "azurerm_network_interface_security_group_association" "web_server_nsg_association" {
#   network_security_group_id = azurerm_network_security_group.web_server_nsg.id
#   network_interface_id      = azurerm_network_interface.web_server_nic.id
# }

# Attach a sg to a subnet
resource "azurerm_subnet_network_security_group_association" "web_server_nsg_association" {
  network_security_group_id = azurerm_network_security_group.web_server_nsg.id
  subnet_id                 = azurerm_subnet.web_server_subnet["web-server"].id
}
