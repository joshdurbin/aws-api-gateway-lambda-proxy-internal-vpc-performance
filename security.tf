resource "aws_key_pair" "keys_to_the_castles" {
  key_name = "castle_keys"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

//resource "aws_security_group" "persistence" {
//
//  name = "persistence"
//  description = "Governs the ELB traffic"
//  vpc_id = "${aws_vpc.load_test_vpc.id}"
//
//  ingress {
//    protocol = "tcp"
//    from_port = 6379
//    to_port = 6379
//    cidr_blocks = ["${var.lambda_subnet_cidr}"]
//  }
//
//  egress {
//    protocol = "-1"
//    from_port = 0
//    to_port = 0
//    cidr_blocks = ["${var.zero_address_default_route_cidr}"]
//  }
//}

resource "aws_security_group" "elb" {

  name = "elb"
  description = "Governs the ELB traffic"
  vpc_id = "${aws_vpc.load_test_vpc.id}"

  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["${var.zero_address_default_route_cidr}"]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["${var.zero_address_default_route_cidr}"]
  }
}

resource "aws_security_group" "lambda" {

  name = "lambda"
  description = "Governs the ELB traffic"
  vpc_id = "${aws_vpc.load_test_vpc.id}"

  ingress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["${var.zero_address_default_route_cidr}"]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["${var.zero_address_default_route_cidr}"]
  }
}

//resource "aws_security_group" "authorizer_lambda" {
//
//  name = "authorizer_lambda"
//  description = "Governs the ELB traffic"
//  vpc_id = "${aws_vpc.load_test_vpc.id}"
//
//  ingress {
//    protocol = "-1"
//    from_port = 0
//    to_port = 0
//    cidr_blocks = ["${var.zero_address_default_route_cidr}"]
//  }
//
//  egress {
//    protocol = "tcp"
//    from_port = 6379
//    to_port = 6379
//    cidr_blocks = ["${var.persistence_cidr_2a}", "${var.persistence_cidr_2b}"]
//  }
//
//  egress {
//    protocol = "tcp"
//    from_port = 5432
//    to_port = 5432
//    cidr_blocks = ["${var.persistence_cidr_2a}", "${var.persistence_cidr_2b}"]
//  }
//}

resource "aws_security_group" "webserver" {

  name = "webserver"
  description = "Governs the nginx box traffic"
  vpc_id = "${aws_vpc.load_test_vpc.id}"

  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["${aws_subnet.lambda.cidr_block}"]
  }

  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["${aws_subnet.elb.cidr_block}"]
  }

  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["${var.zero_address_default_route_cidr}"]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["${var.zero_address_default_route_cidr}"]
  }
}