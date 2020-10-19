variable "bastion_rg" {
  default = "bastion-rg"
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  type = string
  description = "(optional) describe your variable"
}