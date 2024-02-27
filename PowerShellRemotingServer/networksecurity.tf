resource "azurerm_network_security_group" "IPLimits" {
  name = "${var.vm_name}-IPLimits"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location

  security_rule {
    name                        = "AllowRDP"
    priority                    = 1001
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "3389"
    source_address_prefix       = var.allowed_IP
    destination_address_prefix  = "*"
  }

  security_rule {
    name                        = "AllowWinRm"
    priority                    = 1002
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "5986"
    source_address_prefix       = var.allowed_IP
    destination_address_prefix  = "*"
  }

  tags = local.tags
}

resource "azurerm_subnet_network_security_group_association" "nsgassoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.IPLimits.id
}
