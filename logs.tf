resource "aws_cloudwatch_log_group" "trigger_engine" {
  name              = format("%s-logs", local.stack_identifier)
  retention_in_days = var.logs_retention_period
  tags              = local.common_tags
}