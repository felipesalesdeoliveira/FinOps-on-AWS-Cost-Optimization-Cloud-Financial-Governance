resource "aws_budgets_budget" "monthly_cost" {
  name         = var.name
  budget_type  = "COST"
  limit_amount = var.limit_amount_usd
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  dynamic "cost_filter" {
    for_each = var.cost_filters
    content {
      name   = cost_filter.key
      values = cost_filter.value
    }
  }

  dynamic "notification" {
    for_each = var.alert_thresholds
    content {
      comparison_operator        = "GREATER_THAN"
      threshold                  = notification.value
      threshold_type             = "PERCENTAGE"
      notification_type          = "FORECASTED"
      subscriber_sns_topic_arns  = [var.sns_topic_arn]
      subscriber_email_addresses = var.email_subscriptions
    }
  }

  dynamic "notification" {
    for_each = var.alert_thresholds
    content {
      comparison_operator        = "GREATER_THAN"
      threshold                  = notification.value
      threshold_type             = "PERCENTAGE"
      notification_type          = "ACTUAL"
      subscriber_sns_topic_arns  = [var.sns_topic_arn]
      subscriber_email_addresses = var.email_subscriptions
    }
  }
}
