resource "aws_lambda_function" "my_lambda" {
  function_name    = var.name
  handler          = var.handler
  runtime          = var.runtime
  filename         = var.zip_filename
  role             = aws_iam_role.role.arn
  source_code_hash = filebase64sha256(var.zip_filename)
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