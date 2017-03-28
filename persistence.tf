//resource "aws_elasticache_cluster" "auth_cache" {
//  cluster_id = "auth-cache"
//  engine = "redis"
//  engine_version = "3.2.4"
//  node_type = "cache.t2.micro"
//  port = 6379
//  num_cache_nodes = 1
//  parameter_group_name = "default.redis3.2"
//
//  subnet_group_name = "${aws_elasticache_subnet_group.auth_cache.name}"
//  security_group_ids = ["${aws_security_group.persistence.id}"]
//}
//
//resource "aws_elasticache_subnet_group" "auth_cache" {
//  name = "auth-cache"
//  subnet_ids = ["${aws_subnet.persistence.id}"]
//}
//
//resource "aws_rds_cluster_instance" "auth_db" {
//
//}