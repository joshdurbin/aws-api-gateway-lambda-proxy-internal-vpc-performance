#!/bin/bash

ELB="http://public-elb-1171831284.us-west-2.elb.amazonaws.com"
API_GW_LAMBDA="https://4z2sy32w8d.execute-api.us-west-2.amazonaws.com"
API_GW_HTTP_PROXY="https://zefqgwbl3c.execute-api.us-west-2.amazonaws.com"

echo "____________ Testing ELB root ____________________________________________"
siege $ELB --benchmark --time=10S
echo "____________ Testing ELB /child/random.txt _______________________________"
siege $ELB/child/random.txt --benchmark --time=10S
echo "____________ Testing ELB /child/grandchild/random.txt ____________________"
siege $ELB/child/grandchild/random.txt --benchmark --time=10S

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

echo "____________ Testing API Gateway Lambda Proxy root _______________________"
siege $API_GW_LAMBDA/test --benchmark --time=10S
echo "____________ Testing API Gateway Lambda Proxy /child/random.txt __________"
siege $API_GW_LAMBDA/test/child/random.txt --benchmark --time=10S
echo "____________ Testing API Gateway Lambda Proxy /child/grandchild/random.txt"
siege $API_GW_LAMBDA/test/child/grandchild/random.txt --benchmark --time=10S

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

echo "____________ Testing API Gateway HTTP Proxy root _________________________"
siege $API_GW_HTTP_PROXY/test  --benchmark --time=10S
echo "____________ Testing API Gateway HTTP Proxy /child/random.txt ____________"
siege $API_GW_HTTP_PROXY/test/child/random.txt --benchmark --time=10S
echo "____________ Testing API Gateway HTTP Proxy /child/grandchild/random.txt _"
siege $API_GW_HTTP_PROXY/test/child/grandchild/random.txt --benchmark --time=10S