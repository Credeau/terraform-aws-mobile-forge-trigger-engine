data "aws_ssm_parameter" "mongo_user_name" {
  name            = "DUMMY_MONGO_USER"
  with_decryption = true
}

data "aws_ssm_parameter" "mongo_password" {
  name            = "DUMMY_MONGO_PASSWORD"
  with_decryption = true
}

data "aws_ssm_parameter" "postgres_user_name" {
  name            = "DUMMY_POSTGRES_USER"
  with_decryption = true
}

data "aws_ssm_parameter" "postgres_password" {
  name            = "DUMMY_POSTGRES_PASSWORD"
  with_decryption = true
}

module "trigger_engine" {
  source = "git::https://github.com/credeau/terraform-aws-mobile-forge-trigger-engine.git?ref=v1.1.0"

  application            = "di-trigger-engine"
  environment            = "prod"
  region                 = "ap-south-1"
  stack_owner            = "tech@credeau.com"
  stack_team             = "devops"
  organization           = "credeau"
  alert_email_recipients = []

  ecr_repository              = "mobile-forge-trigger-engine"
  ecr_image_tag               = "1.0.0"
  root_volume_size            = 20
  ami_id                      = "ami-00000000000000000"
  key_name                    = "mobile-forge-demo"
  upscale_evaluation_period   = 60
  downscale_evaluation_period = 300
  logs_retention_period       = 7
  scaling_cpu_threshold       = 65
  scaling_memory_threshold    = 50
  scaling_disk_threshold      = 70
  mapped_port                 = 8000
  application_port            = 8000
  timezone                    = "Asia/Kolkata"
  enable_scheduled_scaling    = true
  upscale_schedule            = "0 8 * * MON-SUN"
  downscale_schedule          = "0 21 * * MON-SUN"

  trigger_engine_instance_type                  = "t3a.medium"
  trigger_engine_asg_min_size                   = 1
  trigger_engine_asg_max_size                   = 1
  trigger_engine_asg_desired_size               = 1
  scheduled_upscale_trigger_engine_min_size     = 5
  scheduled_upscale_trigger_engine_max_size     = 20
  scheduled_upscale_trigger_engine_desired_size = 5
  trigger_engine_sms_trigger_config             = "s3://bucket_name/trigger_config.json"
  trigger_engine_extraction_host                = module.extraction.hostname
  trigger_engine_sms_recency_hours              = 720
  sms_mapping_path                              = "s3://bucket_name/india_configs_sms_sender_mapping.json.enc"
  trigger_engine_kafka_topics = [
    "sms_batched"
  ]

  vpc_id = "vpc-00000000000000000"
  private_subnet_ids = [
    "subnet-00000000000000000",
    "subnet-00000000000000000",
  ]

  internal_security_groups = ["sg-00000000000000000"]
  kafka_broker_hosts       = ["52.52.4.235:9092"]
  kafka_host_identifier    = module.kafka.instance_id
  enable_lag_monitoring    = true
  postgres_user_name       = data.aws_ssm_parameter.postgres_user_name.value
  postgres_password        = data.aws_ssm_parameter.postgres_password.value
  postgres_host            = aws_db_instance.postgres.address 
  postgres_port            = 5432
  postgres_db              = aws_db_instance.postgres.db_name
  mongo_username           = data.aws_ssm_parameter.mongo_user_name.value
  mongo_password           = data.aws_ssm_parameter.mongo_password.value
  mongo_host               = module.mongo.host_address
  mongo_port               = 27017
  mongo_db                 = "sync_db"
  mongo_enabled_sources    = ["*"]
}

output "trigger_engine" {
  value = module.trigger_engine
}