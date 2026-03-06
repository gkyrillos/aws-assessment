output "api_url" {
  value = "https://${module.api_gateway[0].api_gateway_id}.execute-api.${var.region}.amazonaws.com/${module.api_gateway[0].stage_name}"
}
