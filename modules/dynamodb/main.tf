resource "aws_dynamodb_table" "dynamodb_tables" {
  for_each = var.dynamodb_tables

  name         = "${each.key}-${var.region}-dynamo-table"
  region       = var.region
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}
