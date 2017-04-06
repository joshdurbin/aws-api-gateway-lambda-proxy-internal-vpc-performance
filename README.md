# aws_api_gateway_proxy_vs_lambda_vs_direct_elb_performance_benchmark

A sample project to show the performance differences proxying requests to internal AWS resources via API Gateway by:

1. Lambda execution
2. HTTP Proxying

Additionally included are the benchmarks against a publically available ELB routing to the same internal resource.

The test can be found in the siege_load_test.sh file which, as the name of the file or test might suggest, requires the
 installation of siege.

A crude snapshot of results looks like...

For the ELB (10 seconds per request, pre-warmed):

| Endpoint                     | Trans Rate    | Avg. Response Time | Total |
| ---------------------------- | ------------- | ------------------ | ----- |
| /                            | 531.63        | 0.07               | 5295  |
| /child/random.txt            | 538.48        | 0.07               | 5374  |
| /child/grandchild/random.txt | 518.64        | 0.07               | 5176  |

For the API Gateway Lambda passthru (10 seconds per request, pre-warmed):

| Endpoint                     | Trans Rate    | Avg. Response Time | Total |
| ---------------------------- | ------------- | ------------------ | ----- |
| /                            | 268.64        | 0.09               | 2681  |
| /child/random.txt            | 270.24        | 0.09               | 2697  |
| /child/grandchild/random.txt | 269.54        | 0.09               | 2690  |

For the API Gateway HTTP Proxy (10 seconds per request, pre-warmed):

| Endpoint                     | Trans Rate    | Avg. Response Time | Total |
| ---------------------------- | ------------- | ------------------ | ----- |
| /                            | 285.77        | 0.08               | 2852  |
| /child/random.txt            | 291.08        | 0.08               | 2905  |
| /child/grandchild/random.txt | 283.77        | 0.08               | 2832  |
