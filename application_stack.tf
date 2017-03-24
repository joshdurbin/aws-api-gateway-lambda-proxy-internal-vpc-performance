resource "aws_elb" "elb" {

  name = "public-elb"
  subnets = ["${aws_subnet.elb.id}"]
  security_groups = ["${aws_security_group.elb.id}"]

  listener {
    instance_port = "80"
    instance_protocol = "http"
    lb_port = "80"
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 3
    timeout = 2
    target = "HTTP:80/"
    interval = 5
  }

  instances = ["${aws_instance.webserver.id}"]

  cross_zone_load_balancing = false
  idle_timeout = 60
  connection_draining = true
  connection_draining_timeout = 300
}

resource "aws_instance" "webserver" {

  ami = "${data.aws_ami.most_recent_ubuntu_xenial.id}"
  instance_type = "t2.nano"
  subnet_id = "${aws_subnet.webserver.id}"
  user_data = "${file("${path.module}/install_nginx.sh")}"
  key_name = "${aws_key_pair.keys_to_the_castles.key_name}"
  vpc_security_group_ids = ["${aws_security_group.webserver.id}"]
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }

}