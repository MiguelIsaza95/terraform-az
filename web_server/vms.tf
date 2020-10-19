#Autosacling group, private instances, we need a bastion to connect to this instances
resource "azurerm_virtual_machine_scale_set" "web_server" {
  name                = "${var.resource_group}-scale-set"
  location            = var.location
  resource_group_name = azurerm_resource_group.web_server_rg.name
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
    admin_password       = data.azurerm_key_vault_secret.admin_password.value
  }
  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
  network_profile {
    name    = "we_server_network_profile"
    primary = true
    ip_configuration {
      name                                   = local.web_server_name
      primary                                = true
      subnet_id                              = azurerm_subnet.web_server_subnet["web-server"].id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.web_server_backend_pool.id]
    }
  }
  extension {
    name                 = "${local.web_server_name}-extension"
    publisher            = "Microsoft.Compute"
    type                 = "CustomScriptExtension"
    type_handler_version = "1.10"

    settings = <<SETTINGS
    {
      "fileUris" : ["https://raw.githubusercontent.com/eltimmo/learning/master/azureInstallWebServer.ps1"],
      "commandToExecute" : "start powershell -ExecutionPolicy Unrestricted -File azureInstallWebServer.ps1"
    }
    SETTINGS
  }
}

# Defining LB
resource "azurerm_lb" "web_server_lb" {
  name                = "${var.resource_group}-lb"
  location            = var.location
  resource_group_name = azurerm_resource_group.web_server_rg.name

  frontend_ip_configuration {
    name                 = "${var.resource_group}-lb-frontend-ip"
    public_ip_address_id = azurerm_public_ip.web_server_public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "web_server_backend_pool" {
  name                = "${var.resource_group}-lb"
  resource_group_name = azurerm_resource_group.web_server_rg.name
  loadbalancer_id     = azurerm_lb.web_server_lb.id
}
resource "azurerm_lb_probe" "web_server_lb_http_probe" {
  name                = "${var.resource_group}-lb-http-probe"
  resource_group_name = azurerm_resource_group.web_server_rg.name
  loadbalancer_id     = azurerm_lb.web_server_lb.id
  protocol            = "tcp"
  port                = 80
}

resource "azurerm_lb_rule" "web_server_lb_http_rule" {
  name                           = "${var.resource_group}-lb-http-rule"
  resource_group_name            = azurerm_resource_group.web_server_rg.name
  loadbalancer_id                = azurerm_lb.web_server_lb.id
  protocol                       = "tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "${var.resource_group}-lb-frontend-ip"
  probe_id                       = azurerm_lb_probe.web_server_lb_http_probe.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.web_server_backend_pool.id
}

#Not in une
# resource "azurerm_availability_set" "web_availability_set" {
#   name                        = "${var.server_name}-avl-set"
#   location                    = var.location
#   resource_group_name         = azurerm_resource_group.web_server_rg.name
#   managed                     = true
#   platform_fault_domain_count = 2
# }

# resource "azurerm_windows_virtual_machine" "web_server" {
#   count                 = var.win_count
#   name                  = "${var.server_name}-${format("%02d", count.index)}"
#   location              = var.location
#   resource_group_name   = azurerm_resource_group.web_server_rg.name
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