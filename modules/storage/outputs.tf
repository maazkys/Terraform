output "storage_account_id" {
  value = azurerm_storage_account.this.id
}

output "private_endpoint_ip" {
  value = azurerm_private_endpoint.blob.private_service_connection[0].private_ip_address
}