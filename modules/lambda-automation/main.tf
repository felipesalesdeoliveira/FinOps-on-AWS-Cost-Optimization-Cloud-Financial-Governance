data "archive_file" "auto_stop" {
  type        = "zip"
  source_file = "${path.module}/src/auto_stop.py"
  output_path = "${path.module}/auto_stop.zip"
}

data "archive_file" "find_untagged" {
  type        = "zip"
  source_file = "${path.module}/src/find_untagged.py"
  output_path = "${path.module}/find_untagged.zip"
}

data "archive_file" "weekly_cost_report" {
  type        = "zip"
  source_file = "${path.module}/src/weekly_cost_report.py"
  output_path = "${path.module}/weekly_cost_report.zip"
}

resource "aws_iam_role" "lambda" {
  name = "${var.name}-finops-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "basic" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "finops" {
  name = "${var.name}-finops-lambda-policy"
  role = aws_iam_role.lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:StopInstances",
          "tag:GetResources",
          "ce:GetCostAndUsage",
          "compute-optimizer:Get*",
          "compute-optimizer:Describe*",
          "sns:Publish"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_lambda_function" "auto_stop" {
  function_name    = "${var.name}-auto-stop"
  role             = aws_iam_role.lambda.arn
  handler          = "auto_stop.lambda_handler"
  runtime          = "python3.12"
  filename         = data.archive_file.auto_stop.output_path
  source_code_hash = data.archive_file.auto_stop.output_base64sha256
  timeout          = 30
  tags             = var.tags
}

resource "aws_lambda_function" "find_untagged" {
  function_name    = "${var.name}-find-untagged"
  role             = aws_iam_role.lambda.arn
  handler          = "find_untagged.lambda_handler"
  runtime          = "python3.12"
  filename         = data.archive_file.find_untagged.output_path
  source_code_hash = data.archive_file.find_untagged.output_base64sha256
  timeout          = 60

  environment {
    variables = {
      REQUIRED_TAGS = join(",", var.required_tags)
      SNS_TOPIC_ARN = var.sns_topic_arn
    }
  }

  tags = var.tags
}

resource "aws_lambda_function" "weekly_cost_report" {
  function_name    = "${var.name}-weekly-cost-report"
  role             = aws_iam_role.lambda.arn
  handler          = "weekly_cost_report.lambda_handler"
  runtime          = "python3.12"
  filename         = data.archive_file.weekly_cost_report.output_path
  source_code_hash = data.archive_file.weekly_cost_report.output_base64sha256
  timeout          = 120

  environment {
    variables = {
      SNS_TOPIC_ARN = var.sns_topic_arn
    }
  }

  tags = var.tags
}

resource "aws_cloudwatch_event_rule" "auto_stop" {
  name                = "${var.name}-auto-stop-schedule"
  schedule_expression = var.auto_stop_schedule_expression
  tags                = var.tags
}

resource "aws_cloudwatch_event_rule" "untagged_scan" {
  name                = "${var.name}-untagged-scan-schedule"
  schedule_expression = var.untagged_scan_schedule_expression
  tags                = var.tags
}

resource "aws_cloudwatch_event_rule" "weekly_report" {
  name                = "${var.name}-weekly-report-schedule"
  schedule_expression = var.weekly_report_schedule_expression
  tags                = var.tags
}

resource "aws_cloudwatch_event_target" "auto_stop" {
  rule      = aws_cloudwatch_event_rule.auto_stop.name
  target_id = "AutoStopLambda"
  arn       = aws_lambda_function.auto_stop.arn
}

resource "aws_cloudwatch_event_target" "untagged_scan" {
  rule      = aws_cloudwatch_event_rule.untagged_scan.name
  target_id = "FindUntaggedLambda"
  arn       = aws_lambda_function.find_untagged.arn
}

resource "aws_cloudwatch_event_target" "weekly_report" {
  rule      = aws_cloudwatch_event_rule.weekly_report.name
  target_id = "WeeklyCostReportLambda"
  arn       = aws_lambda_function.weekly_cost_report.arn
}

resource "aws_lambda_permission" "auto_stop" {
  statement_id  = "AllowExecutionFromEventBridgeAutoStop"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auto_stop.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.auto_stop.arn
}

resource "aws_lambda_permission" "untagged_scan" {
  statement_id  = "AllowExecutionFromEventBridgeUntagged"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.find_untagged.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.untagged_scan.arn
}

resource "aws_lambda_permission" "weekly_report" {
  statement_id  = "AllowExecutionFromEventBridgeWeekly"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.weekly_cost_report.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.weekly_report.arn
}
