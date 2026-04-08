output "name" {
  description = "Name of the Lambda function created"
  value       = aws_lambda_function.lambda.function_name
}

output "arn" {
  description = "Arn of the Lambda function created"
  value       = aws_lambda_function.lambda.arn
}

output "invoke_arn" {
  description = "The invoke ARN of the Lambda function"
  value       = aws_lambda_function.lambda.invoke_arn
}

output "role_arn" {
  description = "The IAM role for the Lambda function"
  value       = aws_iam_role.role.arn
}
