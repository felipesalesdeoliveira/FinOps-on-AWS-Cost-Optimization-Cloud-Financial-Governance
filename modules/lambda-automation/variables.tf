variable "name" {
  type = string
}

variable "sns_topic_arn" {
  type = string
}

variable "required_tags" {
  type    = list(string)
  default = ["Environment", "Owner", "Application", "CostCenter"]
}

variable "auto_stop_schedule_expression" {
  type    = string
  default = "cron(0 23 ? * MON-FRI *)"
}

variable "untagged_scan_schedule_expression" {
  type    = string
  default = "cron(0 12 * * ? *)"
}

variable "weekly_report_schedule_expression" {
  type    = string
  default = "cron(0 13 ? * MON *)"
}

variable "tags" {
  type    = map(string)
  default = {}
}
