locals {
  name = "dev-forbee"
}

module "s3" {
  source = "../../modules/s3"
  name   = "${local.name}-bucket"
}

module "dynamodb" {
  source = "../../modules/dynamodb"
  name   = "${local.name}-table"
}

module "lambda_health" {
  source       = "../../modules/lambda"
  name         = "${local.name}-lambda-health"
  handler      = "health.handler"
  runtime      = "python3.13"
  zip_filename = "./src/health.zip"
}

module "lambda_test" {
  source        = "../../modules/lambda"
  name          = "${local.name}-lambda-test"
  handler       = "index.handler"
  runtime       = "python3.13"
  zip_filename  = "./src/dummy.zip"
  sqs_queue_arn = module.sqs.arn
  sqs_url       = module.sqs.url
}

module "sqs" {
  source = "../../modules/sqs"
  name   = "${local.name}-queue"
}

module "api_gateway" {
  source                     = "../../modules/api_gateway"
  name                       = "${local.name}-api-gateway"
  stage_name                 = "dev"
  health_lambda_uri          = module.lambda_health.invoke_arn
  health_lambda_function_name = module.lambda_health.name
  test_lambda_uri            = module.lambda_test.invoke_arn
  test_lambda_function_name  = module.lambda_test.name
}
