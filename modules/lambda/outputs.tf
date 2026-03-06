output "lambda_invoke_arns" {
  description = "Map of Lambda invoke ARNs for API Gateway integrations."
  value       = { for k, v in aws_lambda_function.lambda_function : k => v.invoke_arn }
}
