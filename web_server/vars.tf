variable "resource_group" {
  type        = string
  default     = "azpractice"
  description = "(optional) describe your variable"
}
variable "environment" {
  type        = string
  default     = "Test"
  description = "(optional) describe your variable"
}
variable "location" {
  type        = string
  default     = "westus2"
  description = "(optional) describe your variable"
}
variable "ssh_public_key" {
  type        = string
  description = "(optional) describe your variable"
}
variable "server_name" {
  type        = string
  default     = "websv"
  description = "(optional) describe your variable"
}
variable "server_number" {
  type        = number
  default     = 1
  description = "(optional) describe your variable"
}
variable "provision_vm_agent" {
  type        = bool
  default     = true
  description = "(optional) describe your variable"
}
variable "servers" {
  type        = list(string)
  default     = ["webServer01", "webServer02"]
  description = "(optional) describe your variable"
}
variable "network" {
  type        = string
  default     = "10.0.0.0/16"
  description = "(optional) describe your variable"
}
variable "subnets" {
  type        = map(string)
  description = "(optional) describe your variable"
  default = {
    web-server = "10.0.16.0/20"
    AzureBastionSubnet = "10.0.32.0/20"
  }
}
variable "win_count" {
  type        = number
  description = "(optional) describe your variable"
}
# Export variable TF_VARS_*
variable "client_id" {}
variable "client_secret" {}