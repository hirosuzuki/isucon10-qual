SERVER_BENCH=34.84.11.210
SERVER_APP=isucon10qual-a
SERVER_WEB=isucon10qual-c
SERVER_DB=isucon10qual-b

build:
	go build

go-get:
	go get -u github.com/hirosuzuki/go-isucon-tracer

import_logs:
	./import_logs.sh $(SERVER_APP) $(SERVER_WEB)

copy-key:
	ssh-copy-id -i ${HOME}/.ssh/id_ed25519.pub ${SERVER_APP}
	ssh-copy-id -i ${HOME}/.ssh/id_ed25519.pub ${SERVER_WEB}
	ssh-copy-id -i ${HOME}/.ssh/id_ed25519.pub ${SERVER_DB}
	ssh-copy-id -i ${HOME}/.ssh/id_ed25519.pub isucon10qual-bastion

init-load:
	mkdir -p initfiles
	scp ${SERVER_APP}:/etc/nginx/nginx.conf initfiles/nginx.conf-a
	scp ${SERVER_WEB}:/etc/nginx/nginx.conf initfiles/nginx.conf-b

deploy-nginx:
	scp nginx.conf ${SERVER_APP}:/tmp/nginx.conf
	ssh ${SERVER_APP} sudo cp /tmp/nginx.conf /etc/nginx/nginx.conf
	ssh ${SERVER_APP} sudo systemctl restart nginx

deploy:
	go build
	scp 0_Schema.sql ${SERVER_APP}:/home/isucon/isuumo/webapp/mysql/db/0_Schema.sql
	ssh ${SERVER_APP} sudo systemctl stop isuumo.go
	scp isuumo ${SERVER_APP}:/home/isucon/isuumo/webapp/go/isuumo
	scp start.sh ${SERVER_APP}:/home/isucon/start.sh
	scp run.sh ${SERVER_APP}:/home/isucon/isuumo/webapp/go/run.sh
	ssh ${SERVER_APP} sudo systemctl start isuumo.go

bench:
	ssh ${SERVER_BENCH} "cd isucon9-final && bench/bin/bench_linux run --payment=http://10.146.15.196:15000 --target=http://10.146.15.196:80 --assetdir=webapp/frontend/dist"

pprof:
	go tool pprof -http="127.0.0.1:8020" logs/latest/cpu.pprof

showdb:
	scp showdb.sh ${SERVER_DB}:showdb.sh
	ssh ${SERVER_DB} sh showdb.sh > table.txt

