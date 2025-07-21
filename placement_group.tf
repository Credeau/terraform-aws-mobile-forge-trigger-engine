resource "aws_placement_group" "main" {
  name            = format("%s-%s", var.application, var.environment)
  strategy        = "partition"
  partition_count = 3
  tags            = local.common_tags
}
