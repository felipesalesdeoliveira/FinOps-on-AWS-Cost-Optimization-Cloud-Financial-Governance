variable "name" {
  type = string
}

variable "account_id" {
  type = string
}

variable "limit_amount_usd" {
  type = string
}

variable "alert_thresholds" {
  type    = list(number)
  default = [50, 80, 100]
}

variable "sns_topic_arn" {
  type = string
}

variable "email_subscriptions" {
  type    = list(string)
  default = []
}

variable "cost_filters" {
  type    = map(list(string))
  default = {}
}
