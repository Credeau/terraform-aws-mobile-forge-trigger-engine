# -----------------------------------------------
# Application and Environment Variables
# -----------------------------------------------
variable "application" {
  type        = string
  description = "application name to refer and mnark across the module"
  default     = "di-trigger-engine"
}

variable "environment" {
  type        = string
  description = "environment type"
  default     = "dev"

  validation {
    condition     = contains(["dev", "prod", "uat"], var.environment)
    error_message = "Environment must be one of: dev, prod, or uat."
  }
}

variable "region" {
  type        = string
  description = "aws region to use"
  default     = "ap-south-1"
}

variable "stack_owner" {
  type        = string
  description = "owner of the stack"
  default     = "tech@credeau.com"
}

variable "stack_team" {
  type        = string
  description = "team of the stack"
  default     = "devops"
}

variable "organization" {
  type        = string
  description = "organization name"
  default     = "credeau"
}

variable "alert_email_recipients" {
  type        = list(string)
  description = "email recipients for sns alerts"
  default     = []
}

variable "log_metric_filters" {
  type = list(object({
    name           = string
    filter_pattern = string
  }))
  description = "list of log metric filters"
  default = [
    {
      name           = "log_errors"
      filter_pattern = "ERROR"
    }
  ]
}

# -----------------------------------------------
# Server & Scaling Variables
# -----------------------------------------------

variable "ecr_repository" {
  type        = string
  description = "aws sync ecr repository"
  default     = "device-insights-consumer"
}

variable "ecr_image_tag" {
  type        = string
  description = "aws sync ecr repository image tag"
  default     = "latest"
}

variable "root_volume_size" {
  type        = number
  description = "size of root volume in GiB"
  default     = 20
}

variable "ami_id" {
  type        = string
  description = "ami to use for instances"
}

variable "key_name" {
  type        = string
  description = "ssh access key name"
}

variable "upscale_evaluation_period" {
  type        = number
  description = "Number of seconds required to observe the system before triggering upscale"
  default     = 60

  validation {
    condition     = var.upscale_evaluation_period == 10 || var.upscale_evaluation_period == 30 || var.upscale_evaluation_period % 60 == 0
    error_message = "Scaling evaluation period can only be 10, 30 or any multiple of 60."
  }
}

variable "downscale_evaluation_period" {
  type        = number
  description = "Number of seconds required to observe the system before triggering downscale"
  default     = 300

  validation {
    condition     = var.downscale_evaluation_period == 10 || var.downscale_evaluation_period == 30 || var.downscale_evaluation_period % 60 == 0
    error_message = "Scaling evaluation period can only be 10, 30 or any multiple of 60."
  }
}

variable "logs_retention_period" {
  type        = number
  description = "No of days to retain the logs"
  default     = 7
}

variable "scaling_cpu_threshold" {
  type        = number
  description = "CPU utilization % threshold for scaling & alerting"
  default     = 65
}

variable "scaling_memory_threshold" {
  type        = number
  description = "Memory utilization % threshold for scaling & alerting"
  default     = 60
}

variable "scaling_disk_threshold" {
  type        = number
  description = "Disk utilization % threshold for scaling & alerting"
  default     = 80
}

variable "mapped_port" {
  type        = number
  description = "mapped port to expose the application"
  default     = 8000
}

variable "application_port" {
  type        = number
  description = "application port to run the application"
  default     = 8000
}

variable "timezone" {
  type        = string
  description = "timezone to use for scheduled scaling"
  default     = "Asia/Kolkata"
}

variable "enable_scheduled_scaling" {
  type        = bool
  description = "enable scheduled scaling"
  default     = false
}

variable "upscale_schedule" {
  type        = string
  description = "upscale schedule"
  default     = "0 8 * * MON-SUN"
}

variable "downscale_schedule" {
  type        = string
  description = "downscale schedule"
  default     = "0 21 * * MON-SUN"
}

variable "lag_threshold" {
  type        = number
  description = "lag threshold for kafka topics"
  default     = 100
}

variable "enable_lag_monitoring" {
  type        = bool
  description = "enable lag monitoring"
  default     = false
}

# -----------------------------------------------
# Trigger Engine Variables
# -----------------------------------------------
variable "trigger_engine_instance_type" {
  type        = string
  description = "Instances type to provision in ASG for trigger engine"
  default     = "t2.micro"
}

variable "trigger_engine_asg_min_size" {
  type        = number
  description = "minimum number of instances to keep in asg for trigger engine"
  default     = 2
}

variable "trigger_engine_asg_max_size" {
  type        = number
  description = "maximum number of instances to keep in asg for trigger engine"
  default     = 5
}

variable "trigger_engine_asg_desired_size" {
  type        = number
  description = "number of instances to provision for trigger engine"
  default     = 2
}

variable "scheduled_upscale_trigger_engine_min_size" {
  type        = number
  description = "minimum number of instances to keep in trigger engine asg for scheduled upscale"
  default     = 5
}

variable "scheduled_upscale_trigger_engine_max_size" {
  type        = number
  description = "maximum number of instances to keep in trigger engine asg for scheduled upscale"
  default     = 10
}

variable "scheduled_upscale_trigger_engine_desired_size" {
  type        = number
  description = "desired number of instances to keep in trigger engine asg for scheduled upscale"
  default     = 5
}

variable "trigger_engine_kafka_topics" {
  type        = list(string)
  description = "kafka topics for trigger engine"
  default = [
    "sms_batched"
  ]
}

variable "trigger_engine_sms_trigger_config" {
  type        = string
  description = "sms trigger config for trigger engine"
}

variable "trigger_engine_extraction_host" {
  type        = string
  description = "extraction host for trigger engine"
}

variable "trigger_engine_sms_recency_hours" {
  type        = number
  description = "sms recency hours for trigger engine to trigger on"
  default     = 24
}

variable "sms_mapping_path" {
  type        = string
  description = "sms mapping path for trigger engine"
}

# -----------------------------------------------
# Network & Security Variables
# -----------------------------------------------

variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "list of private subnet ids to use"
}

variable "internal_security_groups" {
  type        = list(string)
  description = "list of internal access security group ids"
  default     = []
}

# -----------------------------------------------
# External Dependencies Variables
# -----------------------------------------------

variable "kafka_broker_hosts" {
  type        = list(string)
  description = "kafka broker hosts"
  default     = []
}

variable "kafka_host_identifier" {
  type        = string
  description = "kafka host identifier"
  default     = null
}

variable "postgres_user_name" {
  type        = string
  description = "postgres user name"
  default     = null
}

variable "postgres_password" {
  type        = string
  description = "postgres user password"
  default     = null
}

variable "postgres_host" {
  type        = string
  description = "postgres host"
  default     = null
}

variable "postgres_port" {
  type        = number
  description = "postgres port"
  default     = 5432
}

variable "postgres_db" {
  type        = string
  description = "postgres main database"
  default     = null
}

variable "mongo_username" {
  type        = string
  description = "mongo username"
  default     = null
}

variable "mongo_password" {
  type        = string
  description = "mongo password"
  default     = null
}

variable "mongo_host" {
  type        = string
  description = "mongo host"
  default     = null
}

variable "mongo_port" {
  type        = string
  description = "mongo port"
  default     = 27017
}

variable "mongo_db" {
  type        = string
  description = "mongo database"
  default     = null
}

variable "mongo_enabled_sources" {
  type        = list(string)
  description = "mongo enabled sources"
  default     = ["*"]
}

variable "mongo_max_pool_size" {
  type        = number
  description = "mongo max pool size"
  default     = 40
}

variable "mongo_min_pool_size" {
  type        = number
  description = "mongo min pool size"
  default     = 2
}

variable "mongo_server_selection_timeout_ms" {
  type        = number
  description = "mongo server selection timeout"
  default     = 30000
}

variable "mongo_connect_timeout_ms" {
  type        = number
  description = "mongo connect timeout"
  default     = 30000
}

variable "mongo_socket_timeout_ms" {
  type        = number
  description = "mongo socket timeout"
  default     = 30000
}

variable "mongo_retry_writes" {
  type        = bool
  description = "mongo retry writes"
  default     = true
}

variable "mongo_wait_queue_timeout_ms" {
  type        = number
  description = "mongo wait queue timeout"
  default     = 5000
}
