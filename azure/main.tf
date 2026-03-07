terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket         = "multi-cloud-tf-state"
    key            = "azure/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "multi-cloud-tf-lock"
    encrypt        = true
  }
}

provider "azurerm" {
  features {}
}

module "vnet" {
  source              = "./modules/vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_cidr           = var.vnet_cidr
  subnet_cidr         = var.subnet_cidr
}

module "security_group" {
  source              = "./modules/security_group"
  resource_group_name = module.vnet.resource_group_name
  location            = module.vnet.location
}

module "vm" {
  source              = "./modules/vm"
  resource_group_name = module.vnet.resource_group_name
  location            = module.vnet.location
  subnet_id           = module.vnet.subnet_id
  nsg_id              = module.security_group.nsg_id
  admin_username      = var.admin_username
  vm_size             = var.vm_size
}
