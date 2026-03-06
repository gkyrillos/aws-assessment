output "table_arns" {
  description = "A map of user-friendly names to their AWS ARNs"
  value = {
    for name, table in aws_dynamodb_table.dynamodb_tables : name => table.arn
  }
}
