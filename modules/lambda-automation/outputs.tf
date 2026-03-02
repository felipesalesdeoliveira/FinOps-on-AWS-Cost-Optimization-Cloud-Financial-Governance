output "auto_stop_lambda_name" {
  value = aws_lambda_function.auto_stop.function_name
}

output "find_untagged_lambda_name" {
  value = aws_lambda_function.find_untagged.function_name
}

output "weekly_cost_report_lambda_name" {
  value = aws_lambda_function.weekly_cost_report.function_name
}
