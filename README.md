# aws-api-gateway-lambda-proxy-internal-vpc-performance
A sample TF project aimed at staging and testing non-binary query and transmission performance routing to a private
subnet containing nginx via (1) a public ELB and (2) a public API Gateway instance.

The following represents a performance snapshot, testing the two routes:

ELB: (non-SSL)

```text
Transactions:		        8291 hits
Availability:		      100.00 %
Elapsed time:		      119.26 secs
Data transferred:	        4.84 MB
Response time:		        0.11 secs
Transaction rate:	       69.52 trans/sec
Throughput:		        0.04 MB/sec
Concurrency:		        7.62
Successful transactions:        8291
Failed transactions:	           0
Longest transaction:	        3.15
Shortest transaction:	        0.06
```

Lambda: (SSL)

```text
Transactions:		        6965 hits
Availability:		      100.00 %
Elapsed time:		      119.64 secs
Data transferred:	        4.07 MB
Response time:		        0.18 secs
Transaction rate:	       58.22 trans/sec
Throughput:		        0.03 MB/sec
Concurrency:		       10.35
Successful transactions:        6966
Failed transactions:	           0
Longest transaction:	        4.61
Shortest transaction:	        0.13
```