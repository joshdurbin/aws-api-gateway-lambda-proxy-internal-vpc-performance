variable "nat_subnet_cidr" {
  default = "10.0.0.0/24"
}

variable "elb_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "webserver_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "loadtest_subnet_cidr" {
  default = "10.0.3.0/24"
}

variable "lambda_subnet_cidr" {
  default = "10.0.20.0/24" // 10.0.20.0/23 for 512 or 10.0.20.0/22 for 1024
}

variable "default_availability_zone" {
  default = "us-west-2a"
}

variable "availability_zones" {
  type = "list"
  default = ["us-west-2a", "us-west-2b"]
}

variable "region" {
  default = "us-west-2"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "zero_address_default_route_cidr" {
  default = "0.0.0.0/0"
}
