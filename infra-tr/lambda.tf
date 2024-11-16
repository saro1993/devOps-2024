data "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"
}

resource "aws_lambda_function" "image_processor_lambda" {
  function_name    = "image_processor_lambda"
  filename         = "${path.module}/lambda_sqs.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_sqs.zip")
  handler          = "lambda_sqs.lambda_handler"
  runtime          = "python3.8"
  role             = data.aws_iam_role.lambda_execution_role.arn
  timeout          = 30

  environment {
    variables = {
      BUCKET_NAME       = "pgr301-couch-explorers-2024"
      QUEUE_URL         = aws_sqs_queue.image_queue.id
      CANDIDATE_NUMBER  = "101"
    }
  }
}
