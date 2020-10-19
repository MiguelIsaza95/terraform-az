terraform {
  backend "azurerm" {
    resource_group_name  = "az-tfstate"
    storage_account_name = "aztesterraform"
    container_name       = "tfstate"
    key                  = "web.tfstate"
  }
}