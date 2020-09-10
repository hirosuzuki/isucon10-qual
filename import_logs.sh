#!/bin/sh

SERVER_APP=$1
SERVER_WEB=$2
TraceID=$(date +%Y%m%d-%H%M%S)

mkdir -p ./logs/$TraceID/
ln -sfT $TraceID ./logs/latest

ssh $SERVER_APP sudo pkill -HUP isucon7final

ssh $SERVER_WEB <<EOT
sudo mv /var/log/nginx/access.log /var/log/nginx/access-$TraceID.log
sudo systemctl restart nginx
EOT

scp $SERVER_WEB:/var/log/nginx/access-$TraceID.log ./logs/$TraceID/access.log
scp $SERVER_APP:/tmp/cpu.pprof $SERVER_APP:/tmp/perf.log $SERVER_APP:/tmp/sql.log $SERVER_APP:/tmp/vmstat.log ./logs/$TraceID/
