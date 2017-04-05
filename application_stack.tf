resource "aws_elb" "public_elb" {

  name = "public-elb"
  subnets = ["${aws_subnet.elb.id}"]
  security_groups = ["${aws_security_group.elb.id}"]

  listener {
    instance_port = "80"
    instance_protocol = "http"
    lb_port = "80"
    lb_protocol = "http"
  }

  instances = ["${aws_instance.private_webserver.id}"]

  tags {
    Name = "public-elb"
    managed-by-terraform = 1
  }
}

resource "aws_instance" "private_webserver" {

  ami = "${data.aws_ami.most_recent_ubuntu_xenial.id}"
  instance_type = "t2.nano"
  subnet_id = "${aws_subnet.webserver.id}"
  user_data = "${file("${path.module}/install_nginx.sh")}"
  key_name = "${aws_key_pair.keys_to_the_castles.key_name}"
  vpc_security_group_ids = ["${aws_security_group.webserver.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }

  tags {

    Name = "private-webserver"
    managed-by-terraform = 1
  }
}