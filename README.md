# aws_api_gateway_proxy_vs_lambda_vs_direct_elb_performance_benchmark

A sample project to show the performance differences proxying requests to internal AWS resources via API Gateway by:

1. Lambda execution
2. HTTP Proxying

Additionally included are the benchmarks against a publically available ELB routing to the same internal resource.

The test can be found in the siege_load_test.sh file which, as the name of the file or test might suggest, requires the
 installation of siege.

A crude snapshot of results looks like...

For the ELB:

| Endpoint                     | Trans Rate    | Avg. Response Time | Total |
| ---------------------------- | ------------- | ------------------ | ----- |
| /                            | 368.70        | 0.07               | 3687  |
| /child/random.txt            | 381.86        | 0.07               | 3811  |
| /child/grandchild/random.txt | 375.55        | 0.07               | 3748  |

For the API Gateway Lambda passthru:

| Endpoint                     | Trans Rate    | Avg. Response Time | Total |
| ---------------------------- | ------------- | ------------------ | ----- |
| /                            | 289.18        | 0.09               | 2886  |
| /child/random.txt            | 283.47        | 0.09               | 2829  |
| /child/grandchild/random.txt | 293.99        | 0.08               | 2934  |

For the API Gateway HTTP Proxy:

| Endpoint                     | Trans Rate    | Avg. Response Time | Total |
| ---------------------------- | ------------- | ------------------ | ----- |
| /                            | 295.89        | 0.08               | 2953  |
| /child/random.txt            |               |                    |       |
| /child/grandchild/random.txt |               |                    |       |