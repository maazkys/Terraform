resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}
resource "azuread_group" "this" {
  display_name     = var.security_group_name
  security_enabled = true
}