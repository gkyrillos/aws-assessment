output "api_gateway_id" {
  value       = try(aws_api_gateway_rest_api.main[0].id, null)
  description = "The ID of the REST API"
}

output "api_execution_arn" {
  value       = try(aws_api_gateway_rest_api.main[0].execution_arn, null)
  description = "The Execution ARN of the API Gateway"
}

output "authorizer_id" {
  value       = try(aws_api_gateway_authorizer.cognito[0].id, null)
  description = "The ID of the Cognito Authorizer"
}

output "root_resource_id" {
  value       = try(aws_api_gateway_rest_api.main[0].root_resource_id, null)
  description = "The ID of the API Gateway Root Resource"
}

output "stage_name" {
  value       = try(aws_api_gateway_stage.prod[0].stage_name, null)
  description = "The stage name"
}
