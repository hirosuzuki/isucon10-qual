#!/bin/sh

export ISU_DB_HOST=10.146.15.204
export ISU_DB_PORT=3306
export ISU_DB_USER=local_user
export ISU_DB_PASSWORD=password

cd /home/isucon/cco/webapp/go/
exec ./isucon7final 2>/tmp/isucon-stderr.log >/tmp/isucon-stdout.log
