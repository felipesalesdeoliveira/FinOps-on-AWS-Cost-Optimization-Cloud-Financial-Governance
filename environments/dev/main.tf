data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  name = "${var.project_name}-${var.environment}"
  tags = {
    Environment = var.environment
    Owner       = var.owner
    Application = var.application
    CostCenter  = var.cost_center
    Project     = var.project_name
  }

  required_tags_map = {
    Environment = var.environment
    Owner       = var.owner
    Application = var.application
    CostCenter  = var.cost_center
  }
}

resource "aws_compute_optimizer_enrollment_status" "this" {
  count   = var.enable_compute_optimizer ? 1 : 0
  status  = "Active"
  include_member_accounts = false
}

module "sns" {
  source = "../../modules/sns"

  topic_name          = "${local.name}-finops-alerts"
  email_subscriptions = var.email_subscriptions
  tags                = local.tags
}

module "budget" {
  source = "../../modules/budget"

  name                = "${local.name}-monthly-budget"
  account_id          = data.aws_caller_identity.current.account_id
  limit_amount_usd    = var.monthly_budget_usd
  alert_thresholds    = var.budget_alert_thresholds
  sns_topic_arn       = module.sns.topic_arn
  email_subscriptions = var.email_subscriptions
}

module "dashboard" {
  source = "../../modules/dashboard"

  name       = local.name
  aws_region = var.aws_region
}

module "simulation_network" {
  source = "../../modules/network"

  name                 = "${local.name}-sim"
  cidr_block           = var.simulation_vpc_cidr
  azs                  = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnet_cidrs  = var.simulation_public_subnet_cidrs
  private_subnet_cidrs = var.simulation_private_subnet_cidrs
  single_nat_gateway   = true
  tags                 = local.tags
}

module "compute_simulation" {
  source = "../../modules/compute-simulation"

  name             = local.name
  enabled          = var.simulate_spot_ondemand
  subnet_id        = module.simulation_network.public_subnet_ids[0]
  instance_type    = var.simulation_instance_type
  required_tags    = local.required_tags_map
  tags             = local.tags
}

module "lambda_automation" {
  source = "../../modules/lambda-automation"

  name                               = local.name
  sns_topic_arn                      = module.sns.topic_arn
  required_tags                      = var.required_tags
  auto_stop_schedule_expression      = var.auto_stop_schedule_expression
  untagged_scan_schedule_expression  = var.untagged_scan_schedule_expression
  weekly_report_schedule_expression  = var.weekly_report_schedule_expression
  tags                               = local.tags
}
