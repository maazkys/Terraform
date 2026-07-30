terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "stzttfstate4821"
    container_name        = "tfstate"
    key                    = "day4.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

module "identity" {
  source               = "./modules/identity"
  resource_group_name  = "rg-${var.prefix}-${var.environment}"
  location             = var.location
  security_group_name  = "sg-${var.prefix}-${var.environment}-admins"
  tags = {
    project     = "zero-trust-terraform"
    environment = var.environment
  }
}

module "network" {
  source               = "./modules/network"
  resource_group_name  = module.identity.resource_group_name
  location             = module.identity.location
  vnet_name            = "vnet-${var.prefix}-${var.environment}"
  address_space         = ["10.10.0.0/16"]
  subnets = {
    "snet-app" = { address_prefixes = ["10.10.1.0/24"] }
    "snet-pe"  = { address_prefixes = ["10.10.2.0/24"] }
  }
  tags = {
    project     = "zero-trust-terraform"
    environment = var.environment
  }
}

module "keyvault" {
  source                     = "./modules/keyvault"
  resource_group_name        = module.identity.resource_group_name
  location                   = module.identity.location
  name                        = "kv${var.prefix}${var.environment}${random_string.suffix.result}"
  key_vault_admin_object_id  = "d9b1c3be-9cc4-4e8d-9302-e6976a3da188"
  tags = { project = "zero-trust-terraform", environment = var.environment }
}

module "storage" {
  source               = "./modules/storage"
  resource_group_name  = module.identity.resource_group_name
  location             = module.identity.location
  name                  = "st${var.prefix}${var.environment}${random_string.suffix.result}"
  vnet_id              = module.network.vnet_id
  subnet_id            = module.network.subnet_ids["snet-pe"]
  tags = {
    project     = "zero-trust-terraform"
    pipeline = "true"
    environment = var.environment
  }
}
