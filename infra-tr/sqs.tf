resource "aws_sqs_queue" "image_queue" {
  name = "image_processing_queue"
  message_retention_seconds = 345600
  visibility_timeout_seconds = 60
  delay_seconds               = 0 
  max_message_size            = 262144   
  receive_wait_time_seconds   = 10 
}