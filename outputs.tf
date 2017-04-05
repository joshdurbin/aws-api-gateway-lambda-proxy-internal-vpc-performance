output "elb_endpoint" {
  value = "http://${aws_elb.public_elb.dns_name}"
}

output "proxy_api_lambda_passthru_gateway_endpoint" {
  value = "https://${aws_api_gateway_deployment.proxy_api_lambda_passthru.rest_api_id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_deployment.proxy_api_lambda_passthru.stage_name}"
}

output "proxy_api_to_elb_gateway_endpoint" {
  value = "https://${aws_api_gateway_deployment.proxy_api_to_elb.rest_api_id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_deployment.proxy_api_to_elb.stage_name}"
}