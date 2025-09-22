resource "aws_cloudwatch_log_group" "trigger_engine" {
  name              = format("%s-logs", local.stack_identifier)
  retention_in_days = var.logs_retention_period
  tags              = local.common_tags
}

resource "aws_cloudwatch_log_metric_filter" "common_consumer_errors" {
  count = length(var.log_metric_filters)

  name           = format("%s-%s", local.stack_identifier, var.log_metric_filters[count.index].name)
  log_group_name = aws_cloudwatch_log_group.trigger_engine.name
  pattern        = var.log_metric_filters[count.index].filter_pattern

  metric_transformation {
    name      = var.log_metric_filters[count.index].name
    namespace = local.stack_identifier
    value     = 1
  }
}