// NAT Gateways allow private subnets (with machines that do not have public IPs) access the outside world.
// You create them by:
//   (1) Creating a subnet to "house" the NAT which is public (assigns public IPs by default)
//   (2) Create the NAT which lives in the aforementioned subnet
//   (3) Create a route table w/ outbound internet pointed at the IGW and associate with the aforementioned subnet.
//   (4) Create a route table w/ outbound internet pointed at the NAT (and any other peering, etc...) and associate with
//         private application subnets.

resource "aws_eip" "nat_eip" {
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id = "${aws_subnet.nat.id}"
}

resource "aws_route_table" "nat_to_igw" {

  vpc_id = "${aws_vpc.load_test_vpc.id}"

  route {
    cidr_block = "${var.zero_address_default_route_cidr}"
    gateway_id = "${aws_internet_gateway.load_test_vpc_igw.id}"
  }

  tags {
    Name = "nat-to-internet-gateway"
    managed-by-terraform = true
  }
}

resource "aws_route_table_association" "nat_to_igw" {

  subnet_id = "${aws_subnet.nat.id}"
  route_table_id = "${aws_route_table.nat_to_igw.id}"
}

resource "aws_route_table" "private-subnet-net-access" {

  vpc_id = "${aws_vpc.load_test_vpc.id}"

  route {
    cidr_block = "${var.zero_address_default_route_cidr}"
    nat_gateway_id = "${aws_nat_gateway.nat_gateway.id}"
  }

  tags {
    Name = "private-subnet-net-access"
    managed-by-terraform = true
  }
}

resource "aws_route_table_association" "webserver_subnet_to_nat" {

  subnet_id = "${aws_subnet.webserver.id}"
  route_table_id = "${aws_route_table.private-subnet-net-access.id}"
}