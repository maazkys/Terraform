variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "name" { type = string }
variable "tags" { type = map(string) }
variable "key_vault_admin_object_id" {
  type        = string
  description = "Object ID of the user/group that should hold Key Vault Administrator"
}