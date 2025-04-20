output "api_url" {
  value = "https://${aws_api_gateway_rest_api.server_ip_api.id}.execute-api.us-east-1.amazonaws.com/dev/ip"
}
