#!/bin/sh

SERVER_APP=isucon10qual-a
SERVER_WEB=isucon10qual-b
TraceID=$(date +%Y%m%d-%H%M%S)

mkdir -p ./logs/$TraceID/
ln -sfT $TraceID ./logs/latest

ssh $SERVER_APP sudo pkill -HUP isuumo

ssh isucon10qual-a sudo chmod 644 /var/log/nginx/access.log
scp isucon10qual-a:/var/log/nginx/access.log ./logs/$TraceID/access.log
ssh isucon10qual-a sudo mv /var/log/nginx/access.log /var/log/nginx/access-$TraceID.log
ssh isucon10qual-a sudo chmod 644 /var/log/nginx/access-$TraceID.log
ssh isucon10qual-a sudo systemctl restart nginx
scp $SERVER_APP:/tmp/cpu.pprof $SERVER_APP:/tmp/perf.log $SERVER_APP:/tmp/sql.log ./logs/$TraceID/
