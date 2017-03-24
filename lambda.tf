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