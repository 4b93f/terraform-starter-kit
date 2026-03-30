resource "aws_dynamodb_table" "my_table" {
  name         = var.name
  hash_key     = "id"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "S"
  }
}