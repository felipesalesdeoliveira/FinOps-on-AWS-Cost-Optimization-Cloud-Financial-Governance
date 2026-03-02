resource "aws_sns_topic" "this" {
  name = var.topic_name
  tags = var.tags
}

resource "aws_sns_topic_subscription" "email" {
  count = length(var.email_subscriptions)

  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = var.email_subscriptions[count.index]
}
