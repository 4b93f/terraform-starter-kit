module "s3" {

  source      = "../../modules/s3"
  name = "forbee-bucket"
}

module "dynamodb" {
  source              = "../../modules/dynamodb"
  name = "forbee-table"
}

module "lambda" {
  source               = "../../modules/lambda"
  name = "forbee-lambda"
  handler       = "index.handler"
  runtime              = "python3.13"
  zip_filename         = "./src/dummy.zip"
}

module "sqs" {
  source     = "../../modules/sqs"
  queue_name = "forbee-queue"
}

module "api_gateway" {
  source       = "../../modules/api_gateway"
  name = "forbee-api-gateway"
}