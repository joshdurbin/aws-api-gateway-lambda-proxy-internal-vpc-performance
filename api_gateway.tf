resource "aws_api_gateway_rest_api" "proxy_api" {
  name = "proxy_api"
}

resource "aws_api_gateway_resource" "root_proxy_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.proxy_api.id}"
  parent_id = "${aws_api_gateway_rest_api.proxy_api.root_resource_id}"
  path_part = "{proxy+}"
}

resource "aws_api_gateway_method" "root_proxy_resource_method" {
  rest_api_id = "${aws_api_gateway_rest_api.proxy_api.id}"
  resource_id = "${aws_api_gateway_resource.root_proxy_resource.id}"
  http_method = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "root_proxy_resource_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.proxy_api.id}"
  resource_id = "${aws_api_gateway_resource.root_proxy_resource.id}"
  http_method = "${aws_api_gateway_method.root_proxy_resource_method.http_method}"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.proxy_lambda.arn}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_deployment" "proxy_api_poc_deployment" {

  depends_on = ["aws_api_gateway_method.root_proxy_resource_method"]

  rest_api_id = "${aws_api_gateway_rest_api.proxy_api.id}"
  stage_name  = "poc"
}