locals {
  web_server_name   = var.environment == "Test" ? "${var.server_name}ts" : "${var.server_name}po"
  build_environment = var.environment == "Test" ? "test" : "production"
}