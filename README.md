# aws-api-gateway-lambda-proxy-internal-vpc-performance

A sample project to show the performance differences proxying requests to internal AWS resources via API Gateway by:

1. Lambda execution
2. HTTP Proxying

Additionally included are the benchmarks against a publically available ELB routing to the same internal resource.

The test can be found in the siege_load_test.sh file which, as the name of the file or test might suggest, requires the
 installation of siege.

A crude snapshot of results looks like:

```text
____________ Testing ELB root ____________________________________________
[alert] Zip encoding disabled; siege requires zlib support to enable it
** SIEGE 4.0.2
** Preparing 25 concurrent users for battle.
The server is now under siege...
Lifting the server siege...
Transactions:		        3533 hits
Availability:		      100.00 %
Elapsed time:		        9.74 secs
Data transferred:	        2.06 MB
Response time:		        0.07 secs
Transaction rate:	      362.73 trans/sec
Throughput:		        0.21 MB/sec
Concurrency:		       24.91
Successful transactions:        3533
Failed transactions:	           0
Longest transaction:	        0.17
Shortest transaction:	        0.05

____________ Testing ELB /child/random.txt _______________________________
[alert] Zip encoding disabled; siege requires zlib support to enable it
** SIEGE 4.0.2
** Preparing 25 concurrent users for battle.
The server is now under siege...
Lifting the server siege...
Transactions:		        3777 hits
Availability:		      100.00 %
Elapsed time:		        9.98 secs
Data transferred:	        3.69 MB
Response time:		        0.07 secs
Transaction rate:	      378.46 trans/sec
Throughput:		        0.37 MB/sec
Concurrency:		       24.91
Successful transactions:        3777
Failed transactions:	           0
Longest transaction:	        0.15
Shortest transaction:	        0.05

____________ Testing ELB /child/grandchild/random.txt ____________________
[alert] Zip encoding disabled; siege requires zlib support to enable it
** SIEGE 4.0.2
** Preparing 25 concurrent users for battle.
The server is now under siege...
Lifting the server siege...
Transactions:		        3604 hits
Availability:		      100.00 %
Elapsed time:		        9.98 secs
Data transferred:	        7.04 MB
Response time:		        0.07 secs
Transaction rate:	      361.12 trans/sec
Throughput:		        0.71 MB/sec
Concurrency:		       24.87
Successful transactions:        3604
Failed transactions:	           0
Longest transaction:	        0.88
Shortest transaction:	        0.05

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
____________ Testing API Gateway Lambda Proxy root _______________________
[alert] Zip encoding disabled; siege requires zlib support to enable it
** SIEGE 4.0.2
** Preparing 25 concurrent users for battle.
The server is now under siege...
Lifting the server siege...
Transactions:		        2510 hits
Availability:		      100.00 %
Elapsed time:		        9.98 secs
Data transferred:	        1.46 MB
Response time:		        0.10 secs
Transaction rate:	      251.50 trans/sec
Throughput:		        0.15 MB/sec
Concurrency:		       24.87
Successful transactions:        2510
Failed transactions:	           0
Longest transaction:	        0.52
Shortest transaction:	        0.06

____________ Testing API Gateway Lambda Proxy /child/random.txt __________
[alert] Zip encoding disabled; siege requires zlib support to enable it
** SIEGE 4.0.2
** Preparing 25 concurrent users for battle.
The server is now under siege...
Lifting the server siege...
Transactions:		        2783 hits
Availability:		      100.00 %
Elapsed time:		        9.98 secs
Data transferred:	        2.72 MB
Response time:		        0.09 secs
Transaction rate:	      278.86 trans/sec
Throughput:		        0.27 MB/sec
Concurrency:		       24.80
Successful transactions:        2783
Failed transactions:	           0
Longest transaction:	        1.06
Shortest transaction:	        0.06

____________ Testing API Gateway Lambda Proxy /child/grandchild/random.txt
[alert] Zip encoding disabled; siege requires zlib support to enable it
** SIEGE 4.0.2
** Preparing 25 concurrent users for battle.
The server is now under siege...
Lifting the server siege...
Transactions:		        2781 hits
Availability:		      100.00 %
Elapsed time:		        9.98 secs
Data transferred:	        5.43 MB
Response time:		        0.09 secs
Transaction rate:	      278.66 trans/sec
Throughput:		        0.54 MB/sec
Concurrency:		       24.85
Successful transactions:        2781
Failed transactions:	           0
Longest transaction:	        8.24
Shortest transaction:	        0.05

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
____________ Testing API Gateway HTTP Proxy root _________________________
[alert] Zip encoding disabled; siege requires zlib support to enable it
** SIEGE 4.0.2
** Preparing 25 concurrent users for battle.
The server is now under siege...
Lifting the server siege...
Transactions:		        3103 hits
Availability:		      100.00 %
Elapsed time:		        9.98 secs
Data transferred:	        1.81 MB
Response time:		        0.08 secs
Transaction rate:	      310.92 trans/sec
Throughput:		        0.18 MB/sec
Concurrency:		       24.79
Successful transactions:        3103
Failed transactions:	           0
Longest transaction:	        0.87
Shortest transaction:	        0.05

____________ Testing API Gateway HTTP Proxy /child/random.txt ____________
[alert] Zip encoding disabled; siege requires zlib support to enable it
** SIEGE 4.0.2
** Preparing 25 concurrent users for battle.
The server is now under siege...siege aborted due to excessive socket failure; you
can change the failure threshold in $HOME/.siegerc

Transactions:		           0 hits
Availability:		        0.00 %
Elapsed time:		        3.65 secs
Data transferred:	        0.04 MB
Response time:		        0.00 secs
Transaction rate:	        0.00 trans/sec
Throughput:		        0.01 MB/sec
Concurrency:		       24.57
Successful transactions:           0
Failed transactions:	        1048
Longest transaction:	        0.19
Shortest transaction:	        0.00

____________ Testing API Gateway HTTP Proxy /child/grandchild/random.txt _
[alert] Zip encoding disabled; siege requires zlib support to enable it
** SIEGE 4.0.2
** Preparing 25 concurrent users for battle.
The server is now under siege...siege aborted due to excessive socket failure; you
can change the failure threshold in $HOME/.siegerc

Transactions:		           0 hits
Availability:		        0.00 %
Elapsed time:		        4.27 secs
Data transferred:	        0.04 MB
Response time:		        0.00 secs
Transaction rate:	        0.00 trans/sec
Throughput:		        0.01 MB/sec
Concurrency:		       24.64
Successful transactions:           0
Failed transactions:	        1048
Longest transaction:	        0.41
Shortest transaction:	        0.00
```

