locals {
  name = "DEV-forbee"
}

module "s3" {
  source = "../../modules/s3"
  name   = "${local.name}-bucket"
}

module "dynamodb" {
  source = "../../modules/dynamodb"
  name   = "${local.name}-table"
}

module "lambda" {
  source       = "../../modules/lambda"
  name         = "${local.name}-lambda"
  handler      = "index.handler"
  runtime      = "python3.13"
  zip_filename = "./src/dummy.zip"
}

module "sqs" {
  source     = "../../modules/sqs"
  queue_name = "${local.name}-queue"
}

module "api_gateway" {
  source = "../../modules/api_gateway"
  name   = "${local.name}-api-gateway"
}