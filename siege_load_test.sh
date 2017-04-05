#!/bin/bash

echo "____________ Testing ELB root ____________________________________________"
siege http://public-elb-1171831284.us-west-2.elb.amazonaws.com --benchmark --time=10S
echo "____________ Testing ELB /child/random.txt _______________________________"
siege http://public-elb-1171831284.us-west-2.elb.amazonaws.com/child/random.txt --benchmark --time=10S
echo "____________ Testing ELB /child/grandchild/random.txt ____________________"
siege http://public-elb-1171831284.us-west-2.elb.amazonaws.com/child/grandchild/random.txt --benchmark --time=10S

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

echo "____________ Testing API Gateway Lambda Proxy root _______________________"
siege https://4z2sy32w8d.execute-api.us-west-2.amazonaws.com/test --benchmark --time=10S
echo "____________ Testing API Gateway Lambda Proxy /child/random.txt __________"
siege https://4z2sy32w8d.execute-api.us-west-2.amazonaws.com/test/child/random.txt --benchmark --time=10S
echo "____________ Testing API Gateway Lambda Proxy /child/grandchild/random.txt"
siege https://4z2sy32w8d.execute-api.us-west-2.amazonaws.com/test/child/grandchild/random.txt --benchmark --time=10S

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

echo "____________ Testing API Gateway HTTP Proxy root _________________________"
siege https://zefqgwbl3c.execute-api.us-west-2.amazonaws.com/test  --benchmark --time=10S
echo "____________ Testing API Gateway HTTP Proxy /child/random.txt ____________"
siege https://zefqgwbl3c.execute-api.us-west-2.amazonaws.com/test/child/random.txt --benchmark --time=10S
echo "____________ Testing API Gateway HTTP Proxy /child/grandchild/random.txt _"
siege https://zefqgwbl3c.execute-api.us-west-2.amazonaws.com/test/child/grandchild/random.txt --benchmark --time=10S