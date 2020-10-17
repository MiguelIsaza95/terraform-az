#Autosacling group, private instances, we need a bastion to connect to this instances
resource "azurerm_virtual_machine_scale_set" "web_server" {
  name                = "${var.resource_group}-scale-set"
  location            = var.location
  resource_group_name = azurerm_resource_group.web_server_sg.name
  upgrade_policy_mode = "manual"

  sku {
    name     = "Standard_B1s"
    tier     = "Standard"
    capacity = var.win_count
  }
  storage_profile_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  os_profile {
    computer_name_prefix = local.web_server_name
    admin_username       = "webserver"
    admin_password       = "@Password1"
  }
  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile_windows_config {
    provision_vm_agent = true
  }
  network_profile {
    name    = "we_server_network_profile"
    primary = true
    ip_configuration {
      name      = local.web_server_name
      primary   = true
      subnet_id = azurerm_subnet.web_server_subnet["web-server"].id
    }
  }
}


#Not in une
# resource "azurerm_availability_set" "web_availability_set" {
#   name                        = "${var.server_name}-avl-set"
#   location                    = var.location
#   resource_group_name         = azurerm_resource_group.web_server_sg.name
#   managed                     = true
#   platform_fault_domain_count = 2
# }

# resource "azurerm_windows_virtual_machine" "web_server" {
#   count                 = var.win_count
#   name                  = "${var.server_name}-${format("%02d", count.index)}"
#   location              = var.location
#   resource_group_name   = azurerm_resource_group.web_server_sg.name
#   network_interface_ids = [azurerm_network_interface.web_server_nic[count.index].id]
#   availability_set_id   = azurerm_availability_set.web_availability_set.id
#   size                  = "Standard_B1s"
#   admin_username        = "webserver"
#   admin_password        = "@Password1"

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }
#   source_image_reference {
#     publisher = "MicrosoftWindowsServer"
#     offer     = "WindowsServer"
#     sku       = "2016-Datacenter"
#     version   = "latest"
#   }
# }