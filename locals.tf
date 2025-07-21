locals {
  common_tags = {
    Stage    = var.environment
    Owner    = var.stack_owner
    Team     = var.stack_team
    Pipeline = var.application
    Org      = var.organization
  }

  ecr_registry     = format("%s.dkr.ecr.%s.amazonaws.com", data.aws_caller_identity.current.account_id, var.region)
  stack_identifier = format("%s-%s", var.application, var.environment)

  kafka_topic_lag_alert_ladder = [10, 20, 50, 100, 500, 1000, 5000, 10000]
}