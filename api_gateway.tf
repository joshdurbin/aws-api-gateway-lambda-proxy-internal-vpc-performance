resource "aws_api_gateway_rest_api" "proxy_api" {
  name = "proxy_api"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id = "${aws_api_gateway_rest_api.proxy_api.id}"
  resource_id = "${aws_api_gateway_rest_api.proxy_api.root_resource_id}"
  http_method = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id = "${aws_api_gateway_rest_api.proxy_api.id}"
  resource_id = "${aws_api_gateway_rest_api.proxy_api.root_resource_id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  integration_http_method = "ANY"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.proxy_lambda.arn}/invocations"
}

resource "aws_lambda_permission" "apigateway_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.proxy_lambda.arn}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current_identify.account_id}:${aws_api_gateway_rest_api.proxy_api.id}/*/${aws_api_gateway_method.method.http_method}/*"
}