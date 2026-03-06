output "user_pool_client_id" {
  value       = try(aws_cognito_user_pool_client.client[0].id, null)
  description = "The ID of the User Pool Client"
}
