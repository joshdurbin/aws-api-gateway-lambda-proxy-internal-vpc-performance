resource "aws_api_gateway_rest_api" "proxy_api_lambda_passthru" {
  name = "proxy_api_lambda_passthru"
}

resource "aws_api_gateway_method" "proxy_api_lambda_passthru_root_method" {
  rest_api_id = "${aws_api_gateway_rest_api.proxy_api_lambda_passthru.id}"
  resource_id = "${aws_api_gateway_rest_api.proxy_api_lambda_passthru.root_resource_id}"
  http_method = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "proxy_api_lambda_passthru_root_method_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.proxy_api_lambda_passthru.id}"
  resource_id = "${aws_api_gateway_rest_api.proxy_api_lambda_passthru.root_resource_id}"
  http_method = "${aws_api_gateway_method.proxy_api_lambda_passthru_root_method.http_method}"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.proxy_lambda.arn}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_resource" "proxy_api_lambda_passthru_proxy_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.proxy_api_lambda_passthru.id}"
  parent_id = "${aws_api_gateway_rest_api.proxy_api_lambda_passthru.root_resource_id}"
  path_part = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_api_lambda_passthru_proxy_resource_method" {
  rest_api_id = "${aws_api_gateway_rest_api.proxy_api_lambda_passthru.id}"
  resource_id = "${aws_api_gateway_resource.proxy_api_lambda_passthru_proxy_resource.id}"
  http_method = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "proxy_api_lambda_passthru_proxy_resource_method_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.proxy_api_lambda_passthru.id}"
  resource_id = "${aws_api_gateway_resource.proxy_api_lambda_passthru_proxy_resource.id}"
  http_method = "${aws_api_gateway_method.proxy_api_lambda_passthru_proxy_resource_method.http_method}"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.proxy_lambda.arn}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_deployment" "proxy_api_lambda_passthru" {

  depends_on = ["aws_api_gateway_integration.proxy_api_lambda_passthru_root_method_integration", "aws_api_gateway_integration.proxy_api_lambda_passthru_proxy_resource_method_integration"]

  rest_api_id = "${aws_api_gateway_rest_api.proxy_api_lambda_passthru.id}"
  stage_name = "test"
  stage_description = "A deployment of the API which proxies all non-binary requests and responses to a webserver backend."
}