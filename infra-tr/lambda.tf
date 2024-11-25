resource "aws_iam_role" "lambda_execution_role" {
  name               = "lambda_execution_role-101"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_execution_policy" {
  name   = "lambda_execution_policy-101"
  role   = aws_iam_role.lambda_execution_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents", 
          "sqs:GetQueueAttributes",
          
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_lambda_function" "image_processor_lambda" {
  function_name    = "image_processor_lambda"
  filename         = "${path.module}/lambda_sqs.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_sqs.zip")
  handler          = "lambda_sqs.lambda_handler"
  runtime          = "python3.8"
  role             = aws_iam_role.lambda_execution_role.arn
  timeout          = 30

  environment {
    variables = {
      BUCKET_NAME       = "pgr301-couch-explorers"
      QUEUE_URL         = aws_sqs_queue.image_queue.url
      CANDIDATE_NUMBER  = var.student_id
    }
  }
}
