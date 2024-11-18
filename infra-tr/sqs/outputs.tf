output "password" {
  value = aws_iam_user_login_profile.user_login.encrypted_password
}

output "lambda_function_arn" {
  value = aws_lambda_function.image_processor_lambda.arn
}

output "sqs_queue_url" {
  value = aws_sqs_queue.image_queue.id
}
output "iam_student_user_name" {
  value = aws_iam_user.student.name
  description = "Navnet på IAM-brukeren som ble opprettet"
}