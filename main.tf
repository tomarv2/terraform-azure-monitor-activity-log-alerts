resource "azurerm_monitor_activity_log_alert" "this" {
  for_each = var.activity_logs_config != null ? var.activity_logs_config : {}

  name                = each.key
  resource_group_name = each.value.resource_group_name
  scopes              = each.value.scopes
  description         = try(each.value.description, null)

  dynamic "criteria" {
    for_each = each.value.criteria
    content {
      operation_name = criteria.key
      resource_id    = criteria.value.resource_id
      category       = criteria.value.category
    }
  }

  dynamic "action" {
    for_each = try(each.value.action, null) == null ? [] : [each.value.action]
    content {
      action_group_id = action.value.action_group_id
      webhook_properties = action.value.webhook_properties
    }
  }
  enabled = try(each.value.enabled, true)
  tags = merge(var.extra_tags, local.shared_tags)
}

