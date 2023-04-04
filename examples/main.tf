terraform {
  required_version = ">= 1.0.1"
  required_providers {
    azurerm = {
      version = "~> 3.21.1"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_monitor_action_group" "this" {
  name                = "demo_action_group"
  resource_group_name = "<resource_group_name>"
  short_name          = "demo"
}

module "monitor_activity_log_alert" {
  source = "../"

  config = {
    "demo_activity_log" = {
      action_group_name   = "test"
      location            = "westus2"
      resource_group_name = "<resource_group_name>"
      scopes              = ["scopes"]
      "criteria" = {
        "Microsoft.Storage/storageAccounts/read" = {
          resource_id = "<resource id>"
          category    = "Recommendation"
        }
      }
      "action" = {
        action_group_id = azurerm_monitor_action_group.this.id

        webhook_properties = {
          from = "terraform"
        }
      }
    }
  }
}
