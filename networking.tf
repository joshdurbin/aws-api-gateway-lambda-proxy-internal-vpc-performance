resource "aws_vpc" "load_test_vpc" {
  cidr_block = "${var.vpc_cidr}"

  tags {
    Name = "poc_vpc"
  }
}

resource "aws_internet_gateway" "load_test_vpc_igw" {
  vpc_id = "${aws_vpc.load_test_vpc.id}"
}

resource "aws_route" "associate_igw_with_vpc_route_table" {
  route_table_id = "${aws_vpc.load_test_vpc.default_route_table_id}"
  gateway_id = "${aws_internet_gateway.load_test_vpc_igw.id}"
  destination_cidr_block = "${var.zero_address_default_route_cidr}"
}

resource "aws_subnet" "nat" {

  vpc_id = "${aws_vpc.load_test_vpc.id}"
  cidr_block = "${var.nat_subnet_cidr}"
  availability_zone = "us-west-2a"

  tags {
    Name = "nat"
  }
}

resource "aws_subnet" "elb" {
  vpc_id = "${aws_vpc.load_test_vpc.id}"
  cidr_block = "${var.elb_subnet_cidr}"
  availability_zone = "us-west-2a"

  tags {
    Name = "elb"
  }
}

resource "aws_subnet" "webserver" {

  vpc_id = "${aws_vpc.load_test_vpc.id}"
  cidr_block = "${var.webserver_subnet_cidr}"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "lambda" {

  vpc_id = "${aws_vpc.load_test_vpc.id}"
  cidr_block = "${var.lambda_subnet_cidr}"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "authorizer_lambda" {

  vpc_id = "${aws_vpc.load_test_vpc.id}"
  cidr_block = "${var.authorizer_lambda_subnet_cidr}"
  availability_zone = "us-west-2a"
}

//resource "aws_subnet" "persistence_2a" {
//
//  vpc_id = "${aws_vpc.load_test_vpc.id}"
//  cidr_block = "${var.persistence_cidr_2a}"
//  availability_zone = "us-west-2a"
//}
//
//resource "aws_subnet" "persistence_2b" {
//
//  vpc_id = "${aws_vpc.load_test_vpc.id}"
//  cidr_block = "${var.persistence_cidr_2b}"
//  availability_zone = "us-west-2b"
//}