data "archive_file" "proxy_lambda" {

  type = "zip"
  source_file = "${path.module}/proxy.py"
  output_path = "${path.module}/proxy.zip"
}

resource "aws_lambda_function" "proxy_lambda" {

  filename = "${path.module}/proxy.zip"
  description = "Proxy lambda"
  function_name = "proxy"
  role = "${aws_iam_role.proxy_lambda_role.arn}"
  handler = "proxy.lambda_handler"
  source_code_hash = "${data.archive_file.proxy_lambda.output_base64sha256}"
  runtime = "python2.7"
  timeout = 30

  vpc_config {
    subnet_ids = ["${aws_subnet.lambda.*.id}"]
    security_group_ids = ["${aws_security_group.lambda.id}"]
  }

  environment {

    variables {

      webserver_internal_ip = "${aws_instance.private_webserver.private_ip}"
    }
  }
}

resource "aws_lambda_permission" "api_gateway_lambda_permission_root_resource" {
  statement_id  = "AllowExecutionFromAPIGatewayRootResource"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.proxy_lambda.arn}"
  principal = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current_identify.account_id}:${aws_api_gateway_rest_api.proxy_api_lambda_passthru.id}/*/*"
}

resource "aws_lambda_permission" "api_gateway_lambda_permission_proxy_resource" {
  statement_id  = "AllowExecutionFromAPIGatewayProxyResource"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.proxy_lambda.arn}"
  principal = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current_identify.account_id}:${aws_api_gateway_rest_api.proxy_api_lambda_passthru.id}/*/*${aws_api_gateway_resource.proxy_api_lambda_passthru_proxy_resource.path}"
}