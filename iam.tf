resource "aws_iam_instance_profile" "main" {
  name = format("%s-profile", local.stack_identifier)
  role = aws_iam_role.main.name

  tags = local.common_tags
}

resource "aws_iam_role" "main" {
  name = format("%s-role", local.stack_identifier)

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "ssh_policy" {
  role       = aws_iam_role.main.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "main" {
  name = format("%s-policy", local.stack_identifier)
  role = aws_iam_role.main.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:DescribeRegistry",
          "ecr:DescribeRepositories",
          "ecr:GetAuthorizationToken",
          "ecr:GetDownloadUrlForLayer",
          "ecr:ListImages",
          "ecr:ListTagsForResource",
          "ssm:GetParameter",
          "ssm:GetParameters",
          "s3:*"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Sid" : "CWACloudWatchServerPermissions",
        "Effect" : "Allow",
        "Action" : [
          "cloudwatch:PutMetricData",
          "ec2:DescribeVolumes",
          "ec2:DescribeTags",
          "logs:PutLogEvents",
          "logs:PutRetentionPolicy",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups",
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords",
          "xray:GetSamplingRules",
          "xray:GetSamplingTargets",
          "xray:GetSamplingStatisticSummaries"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "CWASSMServerPermissions",
        "Effect" : "Allow",
        "Action" : [
          "ssm:GetParameter"
        ],
        "Resource" : "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:CreateServiceLinkedRole"
        ],
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "iam:AWSServiceName" : [
              "replication.ecr.amazonaws.com"
            ]
          }
        }
      },
    ]
  })
}

# IAM role for EventBridge
resource "aws_iam_role" "consumer_scale_role" {
  name = format("%s-scale-role", local.stack_identifier)

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "consumer_scale_policy" {
  name = format("%s-scale-policy", local.stack_identifier)
  role = aws_iam_role.consumer_scale_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "autoscaling:ExecutePolicy"
        ]
        Resource = [
          aws_autoscaling_policy.trigger_engine_upscale.arn,
          aws_autoscaling_policy.trigger_engine_downscale.arn,
        ]
      }
    ]
  })
}