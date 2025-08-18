<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0, < 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.trigger_engine](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_policy.trigger_engine_downscale](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_autoscaling_policy.trigger_engine_upscale](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_autoscaling_schedule.trigger_engine_scheduled_downscale](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_schedule) | resource |
| [aws_autoscaling_schedule.trigger_engine_scheduled_upscale](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_schedule) | resource |
| [aws_cloudwatch_log_group.trigger_engine](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_metric_alarm.sms_topic_lag](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.trigger_engine_asg_cpu_downscale](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.trigger_engine_asg_cpu_upscale](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.trigger_engine_asg_memory_downscale](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.trigger_engine_asg_memory_upscale](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_iam_instance_profile.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.consumer_scale_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.consumer_scale_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.ssh_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_template.trigger_engine](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_placement_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/placement_group) | resource |
| [aws_sns_topic.alert_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.email_subscriptions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_email_recipients"></a> [alert\_email\_recipients](#input\_alert\_email\_recipients) | email recipients for sns alerts | `list(string)` | `[]` | no |
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | ami to use for instances | `string` | n/a | yes |
| <a name="input_application"></a> [application](#input\_application) | application name to refer and mnark across the module | `string` | `"di-trigger-engine"` | no |
| <a name="input_application_port"></a> [application\_port](#input\_application\_port) | application port to run the application | `number` | `8000` | no |
| <a name="input_downscale_evaluation_period"></a> [downscale\_evaluation\_period](#input\_downscale\_evaluation\_period) | Number of seconds required to observe the system before triggering downscale | `number` | `300` | no |
| <a name="input_downscale_schedule"></a> [downscale\_schedule](#input\_downscale\_schedule) | downscale schedule | `string` | `"0 21 * * MON-SUN"` | no |
| <a name="input_ecr_image_tag"></a> [ecr\_image\_tag](#input\_ecr\_image\_tag) | aws sync ecr repository image tag | `string` | `"latest"` | no |
| <a name="input_ecr_repository"></a> [ecr\_repository](#input\_ecr\_repository) | aws sync ecr repository | `string` | `"device-insights-consumer"` | no |
| <a name="input_enable_lag_monitoring"></a> [enable\_lag\_monitoring](#input\_enable\_lag\_monitoring) | enable lag monitoring | `bool` | `false` | no |
| <a name="input_enable_scheduled_scaling"></a> [enable\_scheduled\_scaling](#input\_enable\_scheduled\_scaling) | enable scheduled scaling | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | environment type | `string` | `"dev"` | no |
| <a name="input_internal_security_groups"></a> [internal\_security\_groups](#input\_internal\_security\_groups) | list of internal access security group ids | `list(string)` | `[]` | no |
| <a name="input_kafka_broker_hosts"></a> [kafka\_broker\_hosts](#input\_kafka\_broker\_hosts) | kafka broker hosts | `list(string)` | `[]` | no |
| <a name="input_kafka_host_identifier"></a> [kafka\_host\_identifier](#input\_kafka\_host\_identifier) | kafka host identifier | `string` | `null` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | ssh access key name | `string` | n/a | yes |
| <a name="input_lag_threshold"></a> [lag\_threshold](#input\_lag\_threshold) | lag threshold for kafka topics | `number` | `100` | no |
| <a name="input_logs_retention_period"></a> [logs\_retention\_period](#input\_logs\_retention\_period) | No of days to retain the logs | `number` | `7` | no |
| <a name="input_mapped_port"></a> [mapped\_port](#input\_mapped\_port) | mapped port to expose the application | `number` | `8000` | no |
| <a name="input_mongo_connect_timeout_ms"></a> [mongo\_connect\_timeout\_ms](#input\_mongo\_connect\_timeout\_ms) | mongo connect timeout | `number` | `30000` | no |
| <a name="input_mongo_db"></a> [mongo\_db](#input\_mongo\_db) | mongo database | `string` | `null` | no |
| <a name="input_mongo_enabled_sources"></a> [mongo\_enabled\_sources](#input\_mongo\_enabled\_sources) | mongo enabled sources | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_mongo_host"></a> [mongo\_host](#input\_mongo\_host) | mongo host | `string` | `null` | no |
| <a name="input_mongo_max_pool_size"></a> [mongo\_max\_pool\_size](#input\_mongo\_max\_pool\_size) | mongo max pool size | `number` | `40` | no |
| <a name="input_mongo_min_pool_size"></a> [mongo\_min\_pool\_size](#input\_mongo\_min\_pool\_size) | mongo min pool size | `number` | `2` | no |
| <a name="input_mongo_password"></a> [mongo\_password](#input\_mongo\_password) | mongo password | `string` | `null` | no |
| <a name="input_mongo_port"></a> [mongo\_port](#input\_mongo\_port) | mongo port | `string` | `27017` | no |
| <a name="input_mongo_retry_writes"></a> [mongo\_retry\_writes](#input\_mongo\_retry\_writes) | mongo retry writes | `bool` | `true` | no |
| <a name="input_mongo_server_selection_timeout_ms"></a> [mongo\_server\_selection\_timeout\_ms](#input\_mongo\_server\_selection\_timeout\_ms) | mongo server selection timeout | `number` | `30000` | no |
| <a name="input_mongo_socket_timeout_ms"></a> [mongo\_socket\_timeout\_ms](#input\_mongo\_socket\_timeout\_ms) | mongo socket timeout | `number` | `30000` | no |
| <a name="input_mongo_username"></a> [mongo\_username](#input\_mongo\_username) | mongo username | `string` | `null` | no |
| <a name="input_mongo_wait_queue_timeout_ms"></a> [mongo\_wait\_queue\_timeout\_ms](#input\_mongo\_wait\_queue\_timeout\_ms) | mongo wait queue timeout | `number` | `5000` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | organization name | `string` | `"credeau"` | no |
| <a name="input_postgres_db"></a> [postgres\_db](#input\_postgres\_db) | postgres main database | `string` | `null` | no |
| <a name="input_postgres_host"></a> [postgres\_host](#input\_postgres\_host) | postgres host | `string` | `null` | no |
| <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password) | postgres user password | `string` | `null` | no |
| <a name="input_postgres_port"></a> [postgres\_port](#input\_postgres\_port) | postgres port | `number` | `5432` | no |
| <a name="input_postgres_user_name"></a> [postgres\_user\_name](#input\_postgres\_user\_name) | postgres user name | `string` | `null` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | list of private subnet ids to use | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | aws region to use | `string` | `"ap-south-1"` | no |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | size of root volume in GiB | `number` | `20` | no |
| <a name="input_scaling_cpu_threshold"></a> [scaling\_cpu\_threshold](#input\_scaling\_cpu\_threshold) | CPU utilization % threshold for scaling & alerting | `number` | `65` | no |
| <a name="input_scaling_disk_threshold"></a> [scaling\_disk\_threshold](#input\_scaling\_disk\_threshold) | Disk utilization % threshold for scaling & alerting | `number` | `80` | no |
| <a name="input_scaling_memory_threshold"></a> [scaling\_memory\_threshold](#input\_scaling\_memory\_threshold) | Memory utilization % threshold for scaling & alerting | `number` | `60` | no |
| <a name="input_scheduled_upscale_trigger_engine_desired_size"></a> [scheduled\_upscale\_trigger\_engine\_desired\_size](#input\_scheduled\_upscale\_trigger\_engine\_desired\_size) | desired number of instances to keep in trigger engine asg for scheduled upscale | `number` | `5` | no |
| <a name="input_scheduled_upscale_trigger_engine_max_size"></a> [scheduled\_upscale\_trigger\_engine\_max\_size](#input\_scheduled\_upscale\_trigger\_engine\_max\_size) | maximum number of instances to keep in trigger engine asg for scheduled upscale | `number` | `10` | no |
| <a name="input_scheduled_upscale_trigger_engine_min_size"></a> [scheduled\_upscale\_trigger\_engine\_min\_size](#input\_scheduled\_upscale\_trigger\_engine\_min\_size) | minimum number of instances to keep in trigger engine asg for scheduled upscale | `number` | `5` | no |
| <a name="input_sms_mapping_path"></a> [sms\_mapping\_path](#input\_sms\_mapping\_path) | sms mapping path for trigger engine | `string` | n/a | yes |
| <a name="input_stack_owner"></a> [stack\_owner](#input\_stack\_owner) | owner of the stack | `string` | `"tech@credeau.com"` | no |
| <a name="input_stack_team"></a> [stack\_team](#input\_stack\_team) | team of the stack | `string` | `"devops"` | no |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | timezone to use for scheduled scaling | `string` | `"Asia/Kolkata"` | no |
| <a name="input_trigger_engine_asg_desired_size"></a> [trigger\_engine\_asg\_desired\_size](#input\_trigger\_engine\_asg\_desired\_size) | number of instances to provision for trigger engine | `number` | `2` | no |
| <a name="input_trigger_engine_asg_max_size"></a> [trigger\_engine\_asg\_max\_size](#input\_trigger\_engine\_asg\_max\_size) | maximum number of instances to keep in asg for trigger engine | `number` | `5` | no |
| <a name="input_trigger_engine_asg_min_size"></a> [trigger\_engine\_asg\_min\_size](#input\_trigger\_engine\_asg\_min\_size) | minimum number of instances to keep in asg for trigger engine | `number` | `2` | no |
| <a name="input_trigger_engine_extraction_host"></a> [trigger\_engine\_extraction\_host](#input\_trigger\_engine\_extraction\_host) | extraction host for trigger engine | `string` | n/a | yes |
| <a name="input_trigger_engine_instance_type"></a> [trigger\_engine\_instance\_type](#input\_trigger\_engine\_instance\_type) | Instances type to provision in ASG for trigger engine | `string` | `"t2.micro"` | no |
| <a name="input_trigger_engine_kafka_topics"></a> [trigger\_engine\_kafka\_topics](#input\_trigger\_engine\_kafka\_topics) | kafka topics for trigger engine | `list(string)` | <pre>[<br>  "sms_batched"<br>]</pre> | no |
| <a name="input_trigger_engine_sms_recency_hours"></a> [trigger\_engine\_sms\_recency\_hours](#input\_trigger\_engine\_sms\_recency\_hours) | sms recency hours for trigger engine to trigger on | `number` | `24` | no |
| <a name="input_trigger_engine_sms_trigger_config"></a> [trigger\_engine\_sms\_trigger\_config](#input\_trigger\_engine\_sms\_trigger\_config) | sms trigger config for trigger engine | `string` | n/a | yes |
| <a name="input_upscale_evaluation_period"></a> [upscale\_evaluation\_period](#input\_upscale\_evaluation\_period) | Number of seconds required to observe the system before triggering upscale | `number` | `60` | no |
| <a name="input_upscale_schedule"></a> [upscale\_schedule](#input\_upscale\_schedule) | upscale schedule | `string` | `"0 8 * * MON-SUN"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | vpc id | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->