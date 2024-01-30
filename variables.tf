variable "vm_username" {
  description = "VM administrator username"
  type        = string
  sensitive   = true
}

variable "vm_password" {
  description = "VM administrator password"
  type        = string
  sensitive   = true
}

variable "rg_name" {
  description = "Resource Group Name"
  type        = string
}

variable "location" {
  description = "Location"
  type        = string
}

variable "vm_name" {
  description = "Name of the VM"
  type        = string
}

variable "computer_name" {
  description = "Name of the Computer"
  type        = string
}

variable "vm_size" {
  description = "Size of the VM"
  type        = string
}

variable "image_publisher" {
  description = "Image publisher info https://az-vm-image.info"
  type        = string
}

variable "image_offer" {
  description = "Image offer info https://az-vm-image.info"
  type        = string
}

variable "image_sku" {
  description = "Image sku info https://az-vm-image.info"
  type        = string
}

variable "vnet_name" {
  description = "VNet Name"
  type        = string
}
