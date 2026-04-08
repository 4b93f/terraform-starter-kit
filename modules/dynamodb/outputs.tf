output "name" {
  description = "Name of the DynamoDB table created"
  value       = aws_dynamodb_table.table.name
}