output "api_gateway_url" {
  value = module.api_gateway.url
}

output "lambda_name" {
  value = module.lambda.name
}

output "sqs_url" {
  value = module.sqs.url
}