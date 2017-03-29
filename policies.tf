data "aws_iam_policy_document" "proxy_lambda_role" {

  statement {
    actions = [ "sts:AssumeRole" ]

    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "proxy_lambda_role" {

  name = "proxy_lambda_role"
  assume_role_policy = "${data.aws_iam_policy_document.proxy_lambda_role.json}"
}

data "aws_iam_policy_document" "proxy_auth_lambda_role" {

  statement {
    actions = [ "sts:AssumeRole" ]

    principals {
      type = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "proxy_auth_lambda_role" {

  name = "proxy_auth_lambda_role"
  assume_role_policy = "${data.aws_iam_policy_document.proxy_auth_lambda_role.json}"
}

resource "aws_iam_role_policy_attachment" "attach_vpc_access" {
  role = "${aws_iam_role.proxy_lambda_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}