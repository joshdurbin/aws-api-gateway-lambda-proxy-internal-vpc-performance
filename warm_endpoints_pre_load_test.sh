#!/bin/bash

ELB=$(terraform output -json | jq .elb_endpoint.value --raw-output)
API_GW_LAMBDA=$(terraform output -json | jq .proxy_api_lambda_passthru_gateway_endpoint.value --raw-output)
API_GW_HTTP_PROXY=$(terraform output -json | jq .proxy_api_to_elb_gateway_endpoint.value --raw-output)

warm_endpoint () {
   curl $1$2 > /dev/null
}

warm_all_endpoints() {
   warm_endpoint $1
   warm_endpoint $1 "/child/random.txt"
   warm_endpoint $1 "/child/grandchild/random.txt"
   warm_endpoint $1 "/random_text_files.zip"
}

warm_all_endpoints $ELB
warm_all_endpoints $API_GW_LAMBDA
warm_all_endpoints $API_GW_HTTP_PROXY
