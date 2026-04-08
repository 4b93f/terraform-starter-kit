resource "aws_lambda_function" "my_lambda" {
  function_name    = var.name
  handler          = var.handler
  runtime          = var.runtime
  filename         = var.zip_filename
  role             = aws_iam_role.role.arn
  source_code_hash = filebase64sha256(var.zip_filename)

  dynamic "environment" {
    for_each = var.enable_sqs ? [1] : []
    content {
      variables = {
        SQS_URL = var.sqs_url
      }
    }
  }
}

resource "aws_iam_role" "role" {
  name = "${var.name}-role"
  tags = var.role_tag

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "sqs_send" {
  count = var.enable_sqs ? 1 : 0
  name  = "${var.name}-sqs-send-policy"
  role  = aws_iam_role.role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:SendMessage",
          "sqs:SendMessageBatch"
        ]
        Effect   = "Allow"
        Resource = var.sqs_queue_arn
      },
    ]
  })
}
