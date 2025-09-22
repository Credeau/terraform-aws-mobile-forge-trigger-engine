resource "aws_autoscaling_group" "trigger_engine" {
  name            = local.stack_identifier
  placement_group = aws_placement_group.main.id

  min_size         = var.trigger_engine_asg_min_size
  desired_capacity = var.trigger_engine_asg_desired_size
  max_size         = var.trigger_engine_asg_max_size

  default_cooldown          = 60  # seconds
  health_check_grace_period = 120 # seconds
  health_check_type         = "EC2"
  vpc_zone_identifier       = var.private_subnet_ids
  termination_policies      = ["OldestInstance"]
  metrics_granularity       = "1Minute"

  launch_template {
    id      = aws_launch_template.trigger_engine.id
    version = aws_launch_template.trigger_engine.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      checkpoint_percentages = [50, 100]
      min_healthy_percentage = 50
      checkpoint_delay       = 120
    }
  }

  # propagate_at_launch is false as instance and volume tags are specified in Launch Template
  tag {
    key                 = "Name"
    value               = local.stack_identifier
    propagate_at_launch = false
  }

  tag {
    key                 = "ResourceType"
    value               = "server"
    propagate_at_launch = false
  }

  dynamic "tag" {
    for_each = local.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = false
    }
  }
}

resource "aws_autoscaling_schedule" "trigger_engine_scheduled_upscale" {
  count = var.enable_scheduled_scaling ? 1 : 0

  scheduled_action_name  = format("%s-scheduled-upscale-action", local.stack_identifier)
  min_size               = var.scheduled_upscale_trigger_engine_min_size
  max_size               = var.scheduled_upscale_trigger_engine_max_size
  desired_capacity       = var.scheduled_upscale_trigger_engine_desired_size
  autoscaling_group_name = aws_autoscaling_group.trigger_engine.name
  time_zone              = var.timezone
  recurrence             = var.upscale_schedule
}

resource "aws_autoscaling_schedule" "trigger_engine_scheduled_downscale" {
  count = var.enable_scheduled_scaling ? 1 : 0

  scheduled_action_name  = format("%s-scheduled-downscale-action", local.stack_identifier)
  min_size               = var.trigger_engine_asg_min_size
  max_size               = var.trigger_engine_asg_max_size
  desired_capacity       = var.trigger_engine_asg_desired_size
  autoscaling_group_name = aws_autoscaling_group.trigger_engine.name
  time_zone              = var.timezone
  recurrence             = var.downscale_schedule
}

resource "aws_autoscaling_policy" "trigger_engine_upscale" {
  name                   = format("%s-upscale-policy", local.stack_identifier)
  scaling_adjustment     = 2 # number of servers to add once triggered
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 0 # seconds
  autoscaling_group_name = aws_autoscaling_group.trigger_engine.name
}

resource "aws_autoscaling_policy" "trigger_engine_downscale" {
  name                   = format("%s-downscale-policy", local.stack_identifier)
  scaling_adjustment     = -1 # number of servers to add once triggered
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300 # seconds
  autoscaling_group_name = aws_autoscaling_group.trigger_engine.name
}

resource "aws_launch_template" "trigger_engine" {
  name          = format("%s-lt", local.stack_identifier)
  instance_type = var.trigger_engine_instance_type


  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = var.root_volume_size
      volume_type = "gp3"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  # Note:
  # use this block only if public ip is required on instances
  # remember to use public subnets in var.subnet_ids
  # ---------------------------------------------------------
  network_interfaces {
    # associate_public_ip_address = true
    security_groups = var.internal_security_groups
  }


  # comment out if above is being used
  # vpc_security_group_ids = var.internal_security_groups

  ebs_optimized = true

  iam_instance_profile {
    arn = aws_iam_instance_profile.main.arn
  }

  image_id = var.ami_id

  key_name = var.key_name

  monitoring {
    enabled = true
  }
  #TODO: Make change in docker read
  user_data = base64encode(templatefile(
    "${path.module}/files/userdata.sh.tftpl",
    {
      region                            = var.region
      registry                          = local.ecr_registry
      ecr_repository                    = var.ecr_repository
      image_tag                         = var.ecr_image_tag
      application                       = var.application
      mapped_port                       = var.mapped_port
      application_port                  = var.application_port
      postgres_user_name                = var.postgres_user_name
      postgres_password                 = var.postgres_password
      postgres_host                     = var.postgres_host
      postgres_port                     = var.postgres_port
      postgres_db                       = var.postgres_db
      mongo_username                    = var.mongo_username
      mongo_password                    = var.mongo_password
      mongo_host                        = var.mongo_host
      mongo_port                        = var.mongo_port
      mongo_db                          = var.mongo_db
      mongo_enabled_sources             = join(",", var.mongo_enabled_sources)
      mongo_max_pool_size               = var.mongo_max_pool_size
      mongo_min_pool_size               = var.mongo_min_pool_size
      mongo_server_selection_timeout_ms = var.mongo_server_selection_timeout_ms
      mongo_connect_timeout_ms          = var.mongo_connect_timeout_ms
      mongo_socket_timeout_ms           = var.mongo_socket_timeout_ms
      mongo_retry_writes                = var.mongo_retry_writes
      mongo_wait_queue_timeout_ms       = var.mongo_wait_queue_timeout_ms
      kafka_broker                      = join(",", var.kafka_broker_hosts)
      kafka_topics                      = join(",", var.trigger_engine_kafka_topics)
      consumer_group                    = local.stack_identifier
      trigger_engine_sms_trigger_config = var.trigger_engine_sms_trigger_config
      trigger_engine_extraction_host    = var.trigger_engine_extraction_host
      trigger_engine_trigger_gap_period = var.trigger_engine_sms_recency_hours
      sms_mapping_path                  = var.sms_mapping_path
      log_group                         = aws_cloudwatch_log_group.trigger_engine.name
    }
  ))

  tags = merge(
    local.common_tags,
    {
      Name : format("%s-lt", local.stack_identifier)
    }
  )

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      local.common_tags,
      {
        Name : local.stack_identifier,
        ResourceType : "server"
      }
    )
  }

  tag_specifications {
    resource_type = "network-interface"

    tags = merge(
      local.common_tags,
      {
        Name : local.stack_identifier,
        ResourceType : "network"
      }
    )
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(
      local.common_tags,
      {
        Name : local.stack_identifier,
        ResourceType : "storage"
      }
    )
  }
}

# -----------------------------------------------
# CloudWatch Alarms
# -----------------------------------------------

resource "aws_cloudwatch_metric_alarm" "trigger_engine_asg_cpu_upscale" {
  alarm_name          = format("%s-dynamic-cpu-upscale", local.stack_identifier)
  alarm_description   = "This metric alarm keeps a watch on CPU usage and triggers trigger_engine asg upscale policy"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.upscale_evaluation_period
  statistic           = "Maximum"
  threshold           = var.scaling_cpu_threshold

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.trigger_engine.name
  }

  alarm_actions = [
    aws_autoscaling_policy.trigger_engine_upscale.arn,
    aws_sns_topic.alert_topic.arn
  ]
}

resource "aws_cloudwatch_metric_alarm" "trigger_engine_asg_cpu_downscale" {
  alarm_name          = format("%s-dynamic-cpu-downscale", local.stack_identifier)
  alarm_description   = "This metric alarm keeps a watch on CPU usage and triggers trigger_engine asg downscale policy"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.downscale_evaluation_period
  statistic           = "Average"
  threshold           = var.scaling_cpu_threshold

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.trigger_engine.name
  }

  alarm_actions = [
    aws_autoscaling_policy.trigger_engine_downscale.arn,
    aws_sns_topic.alert_topic.arn
  ]
}

resource "aws_cloudwatch_metric_alarm" "trigger_engine_asg_memory_upscale" {
  alarm_name          = format("%s-dynamic-memory-upscale", local.stack_identifier)
  alarm_description   = "This metric alarm keeps a watch on memory utilization of trigger_engine asg and send Email Notification"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = var.upscale_evaluation_period
  statistic           = "Maximum"
  threshold           = var.scaling_memory_threshold

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.trigger_engine.name
  }

  alarm_actions = [
    aws_autoscaling_policy.trigger_engine_upscale.arn,
    aws_sns_topic.alert_topic.arn
  ]
}

resource "aws_cloudwatch_metric_alarm" "trigger_engine_asg_memory_downscale" {
  alarm_name          = format("%s-dynamic-memory-downscale", local.stack_identifier)
  alarm_description   = "This metric alarm keeps a watch on Memory usage and triggers trigger_engine asg downscale policy"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 5
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = var.downscale_evaluation_period
  statistic           = "Average"
  threshold           = var.scaling_memory_threshold

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.trigger_engine.name
  }

  alarm_actions = [
    aws_autoscaling_policy.trigger_engine_downscale.arn,
    aws_sns_topic.alert_topic.arn
  ]
}

resource "aws_cloudwatch_metric_alarm" "sms_topic_lag" {
  count = var.enable_lag_monitoring ? length(local.kafka_topic_lag_alert_ladder) : 0

  alarm_name          = format("%s-sms_batched-lag-warning-%s", local.stack_identifier, local.kafka_topic_lag_alert_ladder[count.index])
  alarm_description   = format("This metric alarm keeps a watch on lag of kafka topic sms_batched for threshold %s", local.kafka_topic_lag_alert_ladder[count.index])
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = format("topic_%s_sms_batched_lag", local.stack_identifier)
  namespace           = "CWAgent"
  period              = 60
  statistic           = "Average"
  threshold           = local.kafka_topic_lag_alert_ladder[count.index]

  dimensions = {
    InstanceId = var.kafka_host_identifier
  }

  alarm_actions = [
    aws_sns_topic.alert_topic.arn,
    aws_autoscaling_policy.trigger_engine_upscale.arn
  ]

  ok_actions = [
    aws_sns_topic.alert_topic.arn
  ]
}

resource "aws_cloudwatch_metric_alarm" "trigger_engine_log_errors" {
  count = length(var.log_metric_filters)

  alarm_name          = format("%s-%s", local.stack_identifier, var.log_metric_filters[count.index].name)
  namespace           = local.stack_identifier
  metric_name         = var.log_metric_filters[count.index].name
  statistic           = "Sum"
  period              = 60
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanThreshold"
  treat_missing_data  = "notBreaching"

  alarm_actions = [
    aws_sns_topic.alert_topic.arn
  ]
}
