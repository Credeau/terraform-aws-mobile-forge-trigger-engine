resource "aws_sns_topic" "alert_topic" {
  name = format("%s-%s-alerts", var.organization, local.stack_identifier)
}

resource "aws_sns_topic_subscription" "email_subscriptions" {
  count = length(var.alert_email_recipients)

  topic_arn = aws_sns_topic.alert_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email_recipients[count.index]
}
