output "resource_group_id" {
  value = module.identity.resource_group_id
}

output "vnet_id" {
  value = module.network.vnet_id
}

output "subnet_ids" {
  value = module.network.subnet_ids
}