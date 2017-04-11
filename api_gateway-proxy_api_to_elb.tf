resource "aws_api_gateway_rest_api" "proxy_api_to_elb" {
  name = "proxy_api_to_elb"
}

resource "aws_api_gateway_method" "proxy_api_to_elb_root_method" {
  rest_api_id = "${aws_api_gateway_rest_api.proxy_api_to_elb.id}"
  resource_id = "${aws_api_gateway_rest_api.proxy_api_to_elb.root_resource_id}"
  http_method = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "proxy_api_to_elb_root_method_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.proxy_api_to_elb.id}"
  resource_id = "${aws_api_gateway_rest_api.proxy_api_to_elb.root_resource_id}"
  http_method = "${aws_api_gateway_method.proxy_api_to_elb_root_method.http_method}"
  type = "HTTP_PROXY"
  uri = "http://${aws_elb.public_elb.dns_name}"
  integration_http_method = "${aws_api_gateway_method.proxy_api_to_elb_root_method.http_method}"
}

resource "aws_api_gateway_resource" "proxy_api_to_elb_proxy_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.proxy_api_to_elb.id}"
  parent_id = "${aws_api_gateway_rest_api.proxy_api_to_elb.root_resource_id}"
  path_part = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_api_to_elb_proxy_resource_method" {
  rest_api_id = "${aws_api_gateway_rest_api.proxy_api_to_elb.id}"
  resource_id = "${aws_api_gateway_resource.proxy_api_to_elb_proxy_resource.id}"
  http_method = "ANY"
  authorization = "NONE"

  request_parameters {
    method.request.path.proxy = true
  }
}

resource "aws_api_gateway_integration" "proxy_api_to_elb_proxy_resource_method_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.proxy_api_to_elb.id}"
  resource_id = "${aws_api_gateway_resource.proxy_api_to_elb_proxy_resource.id}"
  http_method = "${aws_api_gateway_method.proxy_api_to_elb_proxy_resource_method.http_method}"
  type = "HTTP_PROXY"
  uri = "http://${aws_elb.public_elb.dns_name}/{proxy}"
  integration_http_method = "${aws_api_gateway_method.proxy_api_to_elb_proxy_resource_method.http_method}"

  request_parameters {
    integration.request.path.proxy = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "proxy_api_to_elb" {

  depends_on = ["aws_api_gateway_integration.proxy_api_to_elb_root_method_integration", "aws_api_gateway_integration.proxy_api_to_elb_proxy_resource_method_integration"]

  rest_api_id = "${aws_api_gateway_rest_api.proxy_api_to_elb.id}"
  stage_name = "test"
  stage_description = "A deployment of the API which proxies all non-binary requests and responses to a webserver backend."
}