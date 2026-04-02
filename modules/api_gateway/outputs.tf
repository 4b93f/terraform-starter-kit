output "name" {
  description = "Name of the API Gateway created"
  value       = aws_api_gateway_rest_api.my_api_gateway.name
}

output "url" {
  description = "Url of the API Gateway created"
  value       = aws_api_gateway_stage.stage.invoke_url
}