output "name" {
  description = "Name of the DynamoDB table created"
  value       = aws_dynamodb_table.my_table.name
}