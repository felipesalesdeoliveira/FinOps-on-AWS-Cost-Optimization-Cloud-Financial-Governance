output "sns_topic_arn" { value = module.sns.topic_arn }
output "budget_name" { value = module.budget.budget_name }
output "dashboard_name" { value = module.dashboard.dashboard_name }
output "auto_stop_lambda_name" { value = module.lambda_automation.auto_stop_lambda_name }
output "find_untagged_lambda_name" { value = module.lambda_automation.find_untagged_lambda_name }
output "weekly_cost_report_lambda_name" { value = module.lambda_automation.weekly_cost_report_lambda_name }
output "simulation_ondemand_instance_id" { value = module.compute_simulation.on_demand_instance_id }
output "simulation_spot_request_id" { value = module.compute_simulation.spot_instance_request_id }
