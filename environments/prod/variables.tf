variable "aws_region" { type = string }
variable "project_name" { type = string }
variable "environment" { type = string }
variable "owner" { type = string }
variable "application" { type = string }
variable "cost_center" { type = string }

variable "email_subscriptions" {
  type    = list(string)
  default = []
}

variable "monthly_budget_usd" {
  type    = string
  default = "300"
}

variable "budget_alert_thresholds" {
  type    = list(number)
  default = [50, 80, 100]
}

variable "enable_compute_optimizer" {
  type    = bool
  default = true
}

variable "required_tags" {
  type    = list(string)
  default = ["Environment", "Owner", "Application", "CostCenter"]
}

variable "simulate_spot_ondemand" {
  type    = bool
  default = false
}

variable "simulation_vpc_cidr" {
  type    = string
  default = "10.90.0.0/16"
}

variable "simulation_public_subnet_cidrs" {
  type    = list(string)
  default = ["10.90.1.0/24", "10.90.2.0/24"]
}

variable "simulation_private_subnet_cidrs" {
  type    = list(string)
  default = ["10.90.11.0/24", "10.90.12.0/24"]
}

variable "simulation_instance_type" {
  type    = string
  default = "t3.micro"
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
