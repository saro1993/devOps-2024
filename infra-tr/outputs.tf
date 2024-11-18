output "password" {
  value = aws_iam_user_login_profile.user_login.encrypted_password
}

output "lambda_function_arn" {
  value = aws_lambda_function.image_processor_lambda.arn
  description = "Lambda function "
}

output "sqs_queue_url" {
  value = aws_sqs_queue.image_queue.url
  description = "URL til SQS-køen"
}
output "iam_student_user_name" {
  value = aws_iam_user.student.name
}
