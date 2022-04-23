# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule

resource "azurerm_network_security_group" "default" {
  name                = "default"
  location            = azurerm_resource_group.NixOS.location
  resource_group_name = azurerm_resource_group.NixOS.name
}

resource "azurerm_network_security_rule" "SSH" {
  name      = "SSH"
  priority  = 100
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  destination_port_range     = "22"
  source_address_prefix      = "*"
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.NixOS.name
  network_security_group_name = azurerm_network_security_group.default.name
}

resource "azurerm_network_interface_security_group_association" "default" {
  network_interface_id      = azurerm_network_interface.default.id
  network_security_group_id = azurerm_network_security_group.default.id
}
