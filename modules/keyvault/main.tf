data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"

  # RBAC mode — no access_policy blocks, matches Week 5's hardening pattern
  enable_rbac_authorization  = true
  purge_protection_enabled   = false   # false for a demo/training env; true in real prod
  soft_delete_retention_days = 7

  tags = var.tags
}

# Grant the deploying identity Key Vault Administrator so you can actually manage secrets afterward
resource "azurerm_role_assignment" "deployer_admin" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Administrator"
  principal_id          = data.azurerm_client_config.current.object_id
}