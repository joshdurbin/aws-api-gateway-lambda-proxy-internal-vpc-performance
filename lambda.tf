data "archive_file" "proxy_lambda" {

  type = "zip"
  source_file = "${path.module}/proxy.py"
  output_path = "${path.module}/proxy.zip"
}

data "archive_file" "auth_proxy_lambda" {

  type = "zip"
  source_dir = "${path.module}/auth_proxy_lambda"
  output_path = "${path.module}/auth_proxy_lambda.zip"
}

resource "aws_lambda_function" "proxy_lambda" {

  filename = "${path.module}/proxy.zip"
  description = "Proxy lambda"
  function_name = "proxy"
  role = "${aws_iam_role.proxy_lambda_role.arn}"
  handler = "proxy.lambda_handler"
  source_code_hash = "${data.archive_file.proxy_lambda.output_base64sha256}"
  runtime = "python2.7"
  timeout = 10

  vpc_config {
    subnet_ids = ["${aws_subnet.lambda.id}"]
    security_group_ids = ["${aws_security_group.lambda.id}"]
  }

  environment {

    variables {

      webserver_internal_ip = "${aws_instance.webserver.private_ip}"
    }
  }
}

//resource "aws_lambda_function" "proxy_lambda" {
//
//  filename = "${path.module}/auth_proxy_lambda.zip"
//  description = "Proxy lambda"
//  function_name = "authorizer"
//  role = "${aws_iam_role.proxy_lambda_role.arn}"
//  handler = "proxy.lambda_handler"
//  source_code_hash = "${data.archive_file.proxy_lambda.output_base64sha256}"
//  runtime = "python2.7"
//  timeout = 10
//
//  vpc_config {
//    subnet_ids = ["${aws_subnet.authorizer_lambda.id}"]
//    security_group_ids = ["${aws_security_group.authorizer_lambda.id}"]
//  }
//
//  environment {
//
//    variables {
//
//      //postgres_rds_ip = "${aws_instance.webserver.private_ip}"
//      //redis_ip =
//    }
//  }
//}

resource "aws_lambda_permission" "apigateway_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.proxy_lambda.arn}"
  principal = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current_identify.account_id}:${aws_api_gateway_rest_api.proxy_api.id}/*/*${aws_api_gateway_resource.root_proxy_resource.path}"
}