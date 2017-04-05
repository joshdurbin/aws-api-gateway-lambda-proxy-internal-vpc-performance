#!/bin/bash

ELB=$(terraform output -json | jq .elb_endpoint.value --raw-output)
API_GW_LAMBDA=$(terraform output -json | jq .proxy_api_lambda_passthru_gateway_endpoint.value --raw-output)
API_GW_HTTP_PROXY=$(terraform output -json | jq .proxy_api_to_elb_gateway_endpoint.value --raw-output)

execute_load_test () {
   echo "--------- Load testing: $1$2 ---------"
   siege $1$2 --benchmark --time=10S --log=load_test_results.log --mark="Load testing: $1$2" --quiet
}

execute_load_test_suite() {
   execute_load_test $1
   execute_load_test $1 "/child/random.txt"
   execute_load_test $1 "/child/grandchild/random.txt"
}

execute_load_test_suite $ELB
execute_load_test_suite $API_GW_LAMBDA
execute_load_test_suite $API_GW_HTTP_PROXY
