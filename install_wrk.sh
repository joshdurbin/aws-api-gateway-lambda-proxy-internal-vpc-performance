#!/bin/bash
apt-get install build-essential unzip libssl-dev -y
mkdir -p /tmp/wrk
cd /tmp/wrk
wget https://codeload.github.com/wg/wrk/zip/4.0.2
unzip 4.0.2
cd wrk-4.0.2
make
cp wrk /usr/bin
rm -Rf /tmp/wrk