terraform {
  required_version = ">= 1.9"
  backend "s3" {
    bucket = "sa-2024-terraform-state"
    key    = "infra/terraform.tfstate"
    region = "eu-west-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.74.0"
    }
  }
}

provider "aws" {
  region = var.region
}





resource "aws_sns_topic" "alarm_topic" {
  name = "${var.sqs_queue_name}-alarm-topic"
}

resource "aws_sns_topic_subscription" "alarm_email_subscription" {
  topic_arn = aws_sns_topic.alarm_topic.arn
  protocol  = "email"
  endpoint  = var.alarm_email  
}

resource "aws_cloudwatch_metric_alarm" "sqs_delay_alarm" {
  alarm_name          = "${var.sqs_queue_name}_ApproximateAgeOfOldestMessage_Alarm"
  namespace           = "AWS/SQS"
  metric_name         = "ApproximateAgeOfOldestMessage"
  dimensions          = {
    QueueName = aws_sqs_queue.image_queue.name
  }
  comparison_operator = "GreaterThanThreshold"
  threshold           = var.threshold
  evaluation_periods  = 2
  period              = 60
  statistic           = "Average"

  alarm_description   = "Alarm when SQS ApproximateAgeOfOldestMessage exceeds threshold"
  alarm_actions       = [aws_sns_topic.alarm_topic.arn]
}
