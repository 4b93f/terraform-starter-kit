output "api_gateway_url" {
  value = module.api_gateway.url
}

output "lambda_health_name" {
  value = module.lambda_health.name
}

output "lambda_test_name" {
  value = module.lambda_test.name
}

output "sqs_url" {
  value = module.sqs.url
}
