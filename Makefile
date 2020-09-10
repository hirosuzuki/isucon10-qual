SERVER_BENCH=34.84.11.210
SERVER_APP=${SERVER_A}
SERVER_WEB=${SERVER_C}
SERVER_DB=${SERVER_B}

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

init-load:
	mkdir -p initfiles
	scp ${SERVER_APP}:/etc/nginx/nginx.conf initfiles/nginx.conf-a
	scp ${SERVER_WEB}:/etc/nginx/nginx.conf initfiles/nginx.conf-b

deploy-nginx:
	scp nginx.conf ${SERVER_WEB}:/tmp/nginx.conf
	ssh ${SERVER_WEB} sudo cp /tmp/nginx.conf /etc/nginx/nginx.conf
	ssh ${SERVER_WEB} sudo systemctl restart nginx

deploy:
	go build
	ssh ${SERVER_APP} sudo systemctl stop cco.golang
	scp isucon7final ${SERVER_APP}:/home/isucon/cco/webapp/go/isucon7final
	scp start.sh ${SERVER_APP}:/home/isucon/start.sh
	scp run.sh ${SERVER_APP}:/home/isucon/cco/webapp/go/run.sh
	ssh ${SERVER_APP} sudo systemctl start cco.golang

bench:
	ssh ${SERVER_BENCH} "cd isucon9-final && bench/bin/bench_linux run --payment=http://10.146.15.196:15000 --target=http://10.146.15.196:80 --assetdir=webapp/frontend/dist"

pprof:
	go tool pprof -http="127.0.0.1:8020" logs/latest/cpu.pprof

showdb:
	scp showdb.sh ${SERVER_DB}:showdb.sh
	ssh ${SERVER_DB} sh showdb.sh > table.txt

