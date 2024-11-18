resource "aws_sqs_queue" "image_queue" {
  name = "image_processing_queue"
  message_retention_seconds = 345600  # 4 dager
  visibility_timeout_seconds = 30
}