resource "aws_cloudwatch_dashboard" "finops" {
  dashboard_name = "${var.name}-finops-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          title  = "Estimated Charges (Total)"
          region = "us-east-1"
          view   = "timeSeries"
          stat   = "Maximum"
          period = 21600
          metrics = [
            ["AWS/Billing", "EstimatedCharges", "Currency", "USD"]
          ]
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          title  = "Estimated Charges (EC2, EKS, ECS)"
          region = "us-east-1"
          view   = "timeSeries"
          stat   = "Maximum"
          period = 21600
          metrics = [
            ["AWS/Billing", "EstimatedCharges", "ServiceName", "AmazonEC2", "Currency", "USD"],
            ["AWS/Billing", "EstimatedCharges", "ServiceName", "AmazonEKS", "Currency", "USD"],
            ["AWS/Billing", "EstimatedCharges", "ServiceName", "AmazonECS", "Currency", "USD"]
          ]
        }
      }
    ]
  })
}
